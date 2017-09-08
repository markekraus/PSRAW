## Functions

### Invoke-RedditRequest

* Fixed error when processing Invoke-WebRequest errors on Core.

### Resolve-RedditDataObject (experimental)

* Public due to class implementation limitations
* Will later be removed.


## Classes

### RedditComment (experimental)

* Now has RedditDataObject base class
* Added Kind instance property
* Added MoreObject property
* Added parentObject property
* Replies is now a RedditComment array
* AccessToken removed
* Added Static RedditThingKind property
* Added Constructor to convert a comment RedditThing to a RedditComment
* Added HasMoreReplies method

### RedditDataObject (experimental)

* Class Added as base class for all Reddit  classes that Contain Data

### RedditHeaderSize

* Added class to represent header Sizes returned from the API

### RedditLink (experimental)

* Added class to represent Links and Self-Posts

### RedditListing (experimental)

* Added class to represent "Listings" returned by the API

### RedditModReport

* Added default Constructor for compatibility

### RedditMore (experimental)

* Added class to represent "Mores" returned by the API

### RedditOAuthToken

* Fixed IsRateLimited() to correctly return False when all values are 0

### RedditSubmission (experimental)

* Added class to house the link and comments for a submission

### RedditSubreddit (experimental)

* Added class to represent Subreddits

### RedditThing (experimental)

* No longer a base class. This is now a meta class to mirror its function in the Reddit API.
* Added constructor to convert a Reddit thing from the API to a RedditThing
* Added default Constructor for compatibility
* Added CreateFrom() Method to create an array of RedditThing objects from a RedditApiResponse

### RedditUserReport

* Added default Constructor for compatibility


## Private Functions

### Get-HttpResponseContentType

* Better null or empty detection

### Wait-RedditApiRateLimit

* More verbose and helpful message


## Build Tools

* Added build.psm1 helper module to to make Building and testing PSRAW easier
* BuildDocs-Helper is now the BuildDocs Module
* CodeCovIo-Helper is now the CodeCovIo Module
* ModuleData-Helper is now the ModuleData Module
* Performance and accuracy tweaks to get-ModuleClass
* psake.ps1 has been radically changed to allow individual tasks to be run more independently and many tasks now rely on build.psm1 functions
* Minor fixes to BuildDocs

## Project Configuration
* Updates to .gitignore to accommodate dotnet builds
* AppVeyor caching enabled to speed up dotnet between builds

## Tests

* All tests have been redone to work with build.psm1's Start-PSRAWPester (now required to run the tests)
* All the insanity blocks have been removed
* WebListener added as an API mock up
* many many test optimizations