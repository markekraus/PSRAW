# Project News

## May 2017

### Core Functionality Milestone Reached!
Release of version 1.1.0.0 brings all the core functionality of PSRAW to production quality. This includes all core functionalities such as OAuth Grant flows for all Grant Flows supported by Reddit, Access Token lifecycle management for all Grant Flows, application & token import/export, and Authenticated API access. All the pieces are now available to begin development on the wrapper functions and Reddit based classes. 

This release does not include any wrapper functions. Future releases will include functions and classes which will make it easier to query, submit, and manage data on Reddit through the API. For this release, what *is* provided is an easy means to make authenticated calls to the API. This done through an `Invoke-WebRequest`-like function `Invoke-RedditRequest`. It handles automatic Rate Limit monitoring & remediation as well as Access Token lifecycle management. You create your application once and request an OAuth Access Token with `Request-RedditOAuthToken` once, and then `Invoke-RedditRequest` will handle the rest with each API call. 

Need to use the Access Token in another script or in the same script later in a different (or unattended) session? `Export-RedditOAuthToken` and `Import-RedditOAuthToken` provide an effortless and secure means to do so.

This is the "core" of this module. From here it is now possible for us to build all the wrapper functions and classes to make the Reddit API PowerShell-friendly. The next minor version release will be the "Base" functionality release. This will include functions and classes to create, delete, read, and reply to subreddit posts, private messages, and comments. 

Between this release and the base functionality release, new features will be added in a backwards compatible way. My hope is that there will be no breaking changes. I believe the  core code is in a flexible enough position to achieve that. If there are breaking changes introduced, they will be announced here. In any case, if you plan to include this in production code, v1.1.0.0 should be stable but I would caution against automatic upgrades until v1.2.0.0.