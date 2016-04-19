$solution = "specflowspike.sln"

function Get-SolutionConfigurations($solution)
{
        Get-Content $solution |
        Where-Object {$_ -match "(?<config>\w+)\|"} |
        %{ $($Matches['config'])} |
        select -uniq
}



$frameworkDirs = @((Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\MSBuild\ToolsVersions\12.0" -Name "MSBuildToolsPath32")."MSBuildToolsPath32",
						"$env:windir\Microsoft.NET\Framework\v4.0.30319\")

    for ($i = 0; $i -lt $frameworkDirs.Count; $i++) {
        $dir = $frameworkDirs[$i]
        if ($dir -Match "\$\(Registry:HKEY_LOCAL_MACHINE(.*?)@(.*)\)") {
            $key = "HKLM:" + $matches[1]
            $name = $matches[2]
            $dir = (Get-ItemProperty -Path $key -Name $name).$name
            $frameworkDirs[$i] = $dir
        }
    }

    $env:path = ($frameworkDirs -join ";") + ";$env:path"

@(Get-SolutionConfigurations $solution) | foreach {
    msbuild $solution /p:Configuration=$_ /verbosity:quiet
}

 
 New-Item "$(get-location)\packages\specflow.2.0.0\tools\specflow.exe.config" -type file -force -value "<?xml version=""1.0"" encoding=""utf-8"" ?> <configuration> <startup> <supportedRuntime version=""v4.0.30319"" /> </startup> </configuration>" | Out-Null

@(Get-SolutionConfigurations $solution)| foreach {
    Start-Job -ScriptBlock {
        param($configuration, $basePath)

        try
        {
			& $basePath\packages\NUnit.Console.3.0.1\tools\nunit3-console.exe /config:$configuration "$basePath/SpecflowSpike/bin/$configuration/SpecflowSpike.dll"
        }
        finally
        {
        }

    } -ArgumentList $_, $(get-location)
}
Get-Job | Wait-Job
Get-Job | Receive-Job


