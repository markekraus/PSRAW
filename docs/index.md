[![Build status](https://ci.appveyor.com/api/projects/status/dirtlaov0dx9i51e/branch/master?svg=true)](https://ci.appveyor.com/project/markekraus/psraw/branch/master)[![Documentation Status](https://readthedocs.org/projects/psraw/badge/?version=latest)](http://psraw.readthedocs.io/en/latest/?badge=latest)[![codecov](https://codecov.io/gh/markekraus/PSRAW/branch/staging/graph/badge.svg)](https://codecov.io/gh/markekraus/PSRAW)

# PSRAW
**P**ower**S**hell **R**eddit **A**PI **W**rapper Module

<img src="http://i.imgur.com/4BCLgcx.png" height="100" width="100"> 

Project Site: [https://github.com/markekraus/PSRAW](https://github.com/markekraus/PSRAW)

- [PSRAW](#psraw)
    - [What Is Reddit?](#what-is-reddit)
    - [What is PSRAW?](#what-is-psraw)
- [News](#news)
    - [August 2017](#august-2017)
        - [PowerShell Core Compatibility Refactor](#powershell-core-compatibility-refactor)
    - [Release Notes](#release-notes)
    - [Change Log](#change-log)
- [Features](#features)
- [Contributing to the PSRAW Project](#contributing-to-the-psraw-project)
- [Using PSRAW](#using-psraw)
    - [Installation](#installation)
    - [Documentation and Help](#documentation-and-help)
    - [Quickstart](#quickstart)

## What Is Reddit? 
[Reddit](https://www.reddit.com) is an American social news aggregation, web content rating, and discussion website. Reddit's registered community members can submit content such as text posts or direct links. Registered users can then vote submissions up or down that determines their position on the page. Submissions with the most up-votes appear on the front page or the top of a category. Content entries are organized by areas of interest called "subreddits". Subreddit topics include news, science, gaming, movies, music, books, fitness, food, image-sharing, and many others. The site prohibits harassment, and moderation requires substantial resources. (Source: [Wikipedia](https://en.wikipedia.org/wiki/Reddit))

## What is PSRAW?
PSRAW is a Reddit API Wrapper module for the PowerShell scripting language. PSRAW allows for PowerShell command and object based access to [Reddit's REST API](https://www.reddit.com/dev/api/). This allows for full access to all of Reddit's features including commenting, posting, messaging, and moderation provided by Reddit's API via PowerShell.

This module was created by Mark Kraus as new iteration of the [ConnectReddit](https://github.com/markekraus/ConnectReddit) module. It is heavily inspired by the [PRAW](https://praw.readthedocs.io/en/latest/) module for the python language and the [PSMSGraph](https://github.com/markekraus/PSMSGraph) PowerShell module for Microsoft Graph API.

# News

## August 2017

### PowerShell Core Compatibility Refactor
Many Many changes have been made to the module to make it compatible with PowerShell Core. The upcoming release will be a major version and many breaking changes will be introduced. Chief among them are the removal of the `Code` and `Implicit` grant flows. These grant flows required a GUI and GUI is not possible in PowerShell Core. In the future we will investigate bringing these grant flows back through CLI means. The current estimates for doing so would set this project back even further. We would rather provide the "Base" functionality release before tackling the additional grant flows. For most use cases for this module, the `Script` grant flow should be sufficient.

This release will not add any additional functionality for users. Most of the changes are taking place "under the hood". The underlying class structures for upcoming functionality (such as retrieving comments) are being added but with no current functionality. If you begin using these classes in your projects please note that their shape and functionality may change dramatically in coming minor versions.


For All news see the [Project News](Project/News.md) page.

## Release Notes
[Release Notes](RELEASE.md)

## Change Log
[Change Log](ChangeLog.md)

# Features
* Compatible with PowerShell Core on Windows (currently not cross-platform)
* In-memory and at-rest security of the Access Token, Refresh Token, Client Secret, and User Password. 
* PowerShell v5 Classes for Reddit objects
* Easy OAuth authorization process
* No "Mystery DLL's" required. The entire OAuth authorization, token request, and token refresh process is written in native PowerShell
* Export and Import Access Tokens between sessions allowing you to authorize an application once and reuse the token until the refresh token has been revoked. Great for automation!
* No hassle Access Token Refreshing! Calls to `Invoke-RedditRequest` (and all the functions that call it) automatically track the renewal needs for your Access Tokens and will automatically refresh them when needed.
* Built in Rate Limit monitoring, detection, and cooldown
* Rigorously tested code
* Thorough Online and In-Console Help Documentation

# Contributing to the PSRAW Project
PSRAW is a community module made by the community for the community. However, the goal of this project is to maintain high quality best practice code and high quality documentation. We encourage community contributions but there are several considerations to be aware of before contributing. For more information see the [Contributing to PSRAW](Project/Contributing.md) document.

# Using PSRAW

## Installation
PSRAW is available on the [PowerShell Gallery](https://www.powershellgallery.com/packages/psraw/). 

To Inspect:
```powershell
Save-Module -Name PSRAW -Path <path> 
```
To install:
```powershell
Install-Module -Name PSRAW
```

## Documentation and Help
The online documentation for this module is available at [https://psraw.readthedocs.io/](https://psraw.readthedocs.io/)

The in-console documentation can be access with `Get-Help`, for example:

```powershell
Get-Help Invoke-RedditRequest -Full
Get-Help about_RedditOAuthToken
```

## Quickstart
To see a quick example of how to use PSRAW see the [Quickstart Example](Examples/Quickstart.md) document.