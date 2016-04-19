# README #

This README would normally document whatever steps are necessary to get your application up and running.

### What is this repository for? ###

* Spike for all things Specflow and test automation
* Version 0.0.0.1
* [Learn Markdown](https://bitbucket.org/tutorials/markdowndemo)

### How do I get set up? ###

#General#
* Restore NuGet Packages
* Install NUnit 3.0.1
* Install HAR Trigger Export (FF Plugin)
* Install NodeJs & package YSlow (with npm install yslow -g)
* Install NUnit Adapter for easy test running in Visual Studio
* Create C:\Test Failures for screen shot capture

#Load/ Performance#
Odds are pretty good that your production application has some kind of performance monitoring in place (e.g., New Relic). This goes a long way towards identifying when something detrimental has been released into the wild.

But how do you catch performance issues before they reach production?

Rather than identify specific benchmarks to check, let's run through a gamut of them by leveraging a pre-existing benchmarking tool like YSlow. Fortunately, there is a command-line YSlow tool that can consume a HAR file and provide us with useful output.

It's a Node.js app. So first you'll need to install Node.js, and then install the app (with npm install yslow -g).

* Create Custom FF Profile - Reference it in Load.Spike TestRunContext. This profile must have HAR Trigger Export installed and configured correctly
* http://www.softwareishard.com/blog/har-export-trigger/

>Prefs: extensions.netmonitor.har.contentAPIToken test

>Prefs: extensions.netmonitor.har.autoConnect true

>Prefs: extensions.netmonitor.har.enableAutomation true

* Add C:\Har & C:\HarArchive directories

Expected Behavior
	* Load the browser
	* Capture all requests through browser network traffic
	* Save the captured requests to a HTTP Archive (HAR) file on disk
	* Run the HAR file through YSlow to get a numeric grade
	* Assert that the grade is above a certain level
	* Archive the HAR file on disk

#Specflow#
* Configuration in App.Config
* Slow Cheetah if you intended to add more config transforms
* Run BrowserStack.exe <ApiKey> to allow BrowserStack tunnelling

#Api#
* No special requirements

### Contribution guidelines ###

* Writing tests: Gherkin & Specflow

### Who do I talk to? ###

* Repo owner or admin
* Other community or team contact