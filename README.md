[![Build status](https://ci.appveyor.com/api/projects/status/dirtlaov0dx9i51e/branch/master?svg=true)](https://ci.appveyor.com/project/markekraus/psraw/branch/master)

# PSRAW
PowerShell Reddit API Wrapper Module

## What Is Reddit? 
[Reddit](https://www.reddit.com) is an American social news aggregation, web content rating, and discussion website. Reddit's registered community members can submit content such as text posts or direct links. Registered users can then vote submissions up or down that determines their position on the page. Submissions with the most up-votes appear on the front page or the top of a category. Content entries are organized by areas of interest called "subreddits". Subreddit topics include news, science, gaming, movies, music, books, fitness, food, image-sharing, and many others. The site prohibits harassment, and moderation requires substantial resources. (Source: [Wikipedia](https://en.wikipedia.org/wiki/Reddit))

## What is PSRAW?
PSRAW is a Reddit API Wrapper module for the PowerShell scripting language. PRAW allows for PowerShell command and object based access to [Reddit's REST API](https://www.reddit.com/dev/api/). This allows for full access to all of Reddit's features including commenting, posting, messaging, and moderation provided by Reddit's API via PowerShell.

This module was created by Mark Kraus as new itteration of the [ConnectReddit](https://github.com/markekraus/ConnectReddit) module. It is heavily inspired by the [PRAW](https://praw.readthedocs.io/en/latest/) module for the python language and the [PSMSGraph](https://github.com/markekraus/PSMSGraph/blob/master/README.md) PowerShell module for Microsoft Graph API.

### Features
* In-memory and at-rest security of the Access Token, Refresh Token, Client Secret, and User Password. 
* Extensible type system (Mark's "Poor Man's Classes") allows for piping between functions similar to Active Directory or Exchange cmdlets
* Easy OAuth authorization process with a WinForms authentication popup
* No "mystery DLL's" required. The entire OAuth authorization, token request, and token refresh process is written in pure PowerShell
* Export and Import access tokens between sessions allowing you to authorize an application once and reuse the token until the refresh expires from lack of use or is revoked. Great for automation!
* No hassle Token Refreshing!! Calls to ```Invoke-RedditRequest``` (and all the functions that utilize it) automatically track the renewal needs for your Access Tokens and will automatically refresh them when needed.

### Contributing to the PSRAW Project
Coming soon

## Installation
PSRAW will soon be available on the PowerShell Gallery. 

Dowload the [PSRAW](https://github.com/markekraus/PSRAW/tree/master/PSRAW) folder and all its contents and place them in your PowerShell modules folder.

## Documentaion
The documentation for this module will soon be available on readthedocs.io

## Quickstart
Coming soon

## Release Notes
[https://github.com/markekraus/PSRAW/blob/master/RELEASE.md](https://github.com/markekraus/PSRAW/blob/master/RELEASE.md)

## Change Log
[https://github.com/markekraus/PSRAW/blob/master/docs/ChangeLog.md](https://github.com/markekraus/PSRAW/blob/master/docs/ChangeLog.md)

