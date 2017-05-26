[![Build status](https://ci.appveyor.com/api/projects/status/dirtlaov0dx9i51e/branch/master?svg=true)](https://ci.appveyor.com/project/markekraus/psraw/branch/master)[![Documentation Status](https://readthedocs.org/projects/psraw/badge/?version=latest)](http://psraw.readthedocs.io/en/latest/?badge=latest)[![codecov](https://codecov.io/gh/markekraus/PSRAW/branch/staging/graph/badge.svg)](https://codecov.io/gh/markekraus/PSRAW)

# PSRAW
**P**ower**S**hell **R**eddit **A**PI **W**rapper Module

- [PSRAW](#psraw)
    - [What Is Reddit?](#what-is-reddit)
    - [What is PSRAW?](#what-is-psraw)
- [News](#news)
    - [May 2017](#may-2017)
        - [Core Functionality Milestone Reached!](#core-functionality-milestone-reached)
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

## May 2017

### Core Functionality Milestone Reached!
Release of version 1.1.0.0 brings all the core functionality of PSRAW to production quality. This includes all core functionalities such as OAuth Grant flows for all Grant Flows supported by Reddit, Access Token lifecycle management for all Grant Flows, application & token import/export, and Authenticated API access. All the pieces are now available to begin development on the wrapper functions and Reddit based classes. 

This release does not include any wrapper functions. Future releases will include functions and classes which will make it easier to query, submit, and manage data on Reddit through the API. For this release, what *is* provided is an easy means to make authenticated calls to the API. This done through an `Invoke-WebRequest`-like function `Invoke-RedditRequest`. It handles automatic Rate Limit monitoring & remediation as well as Access Token lifecycle management. You create your application once and request an OAuth Access Token with `Request-RedditOAuthToken` once, and then `Invoke-RedditRequest` will handle the rest with each API call. 

Need to use the Access Token in another script or in the same script later in a different (or unattended) session? `Export-RedditOAuthToken` and `Import-RedditOAuthToken` provide an effortless and secure means to do so.

This is the "core" of this module. From here it is now possible for us to build all the wrapper functions and classes to make the Reddit API PowerShell-friendly. The next minor version release will be the "Base" functionality release. This will include functions and classes to create, delete, read, and reply to subreddit posts, private messages, and comments. 

Between this release and the base functionality release, new features will be added in a backwards compatible way. My hope is that there will be no breaking changes. I believe the  core code is in a flexible enough position to achieve that. If there are breaking changes introduced, they will be announced here. In any case, if you plan to include this in production code, v1.1.0.0 should be stable but I would caution against automatic upgrades until v1.2.0.0.

For this and all news items see the [Project News](tree/master/docs/Project/News.md) page.

## Release Notes
[Release Notes](tree/master/RELEASE.md)

## Change Log
[Change Log](tree/master/docs/ChangeLog.md)

# Features
* In-memory and at-rest security of the Access Token, Refresh Token, Client Secret, and User Password. 
* PowerShell v5 Classes for Reddit objects
* Easy OAuth authorization process with a WinForms authentication popup for applicable grant flows
* No "Mystery DLL's" required. The entire OAuth authorization, token request, and token refresh process is written in native PowerShell
* Export and Import Access Tokens between sessions allowing you to authorize an application once and reuse the token until the refresh token has been revoked. Great for automation!
* No hassle Access Token Refreshing! Calls to `Invoke-RedditRequest` (and all the functions that call it) automatically track the renewal needs for your Access Tokens and will automatically refresh them when needed.
* Build in Rate Limit monitoring, detection, and cooldown
* Rigorously tested code
* Thorough Online and In-Console Help Documentation

# Contributing to the PSRAW Project
PSRAW is a community module made by the community for the community. However, the goal of this project is to maintain high quality best practice code and high quality documentation. We encourage community contributions but there are several considerations to be aware of before contributing. For more information see the [Contributing to PSRAW](tree/master/docs/Project/Contributing.md) document.

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
To see a quick example of how to use PSRAW see the [Quickstart Example](tree/master/docs/Examples/Quickstart.md) document.