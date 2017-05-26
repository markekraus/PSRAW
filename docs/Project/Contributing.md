# Contributing to PSRAW

## Thanks for Considering Contributing to the PSRAW Project!

First, if you are reading this, I sincerely wish to thank you for even considering donating some of you time to working on the PSRAW project. For this project to be as successful as Reddit API Wrappers for other languages, a large amount of code will need to be written. With more Volunteers this goal can be actualized much sooner than a lone developer working in his spare time. 

But, you don't have to make large code contributions to this project to make an impact on this project. Minor bug fixes and documentation correction are just as valuable to the overall goals of this project.

 I want to make the process as easy as possible to get involved while still maintaining a high level of best practices code and documentation. If you have any questions, concerns or suggestions please feel free to email me at [psraw@markekraus.com](mailto:psraw@markekraus.com), on reddit at [/u/markekraus](https://www.reddit.com/user/markekraus/), or on Twitter [@markekraus](https://twitter.com/markekraus).

Now, on to business!

# Code Formatting and Conventions

## Fomratting
All code must be properly formatted for a PR to be merged. For examples of the formatting, see source code for `Invoke-RedditRequest`. If you are using VS Code, the following settings should produce the desired code formating:

```json
{
  "powershell.codeFormatting.openBraceOnSameLine": true,
  "powershell.codeFormatting.newLineAfterOpenBrace": true,
  "powershell.codeFormatting.newLineAfterCloseBrace": true,
  "powershell.codeFormatting.whitespaceBeforeOpenBrace": true,
  "powershell.codeFormatting.whitespaceBeforeOpenParen": true,
  "powershell.codeFormatting.whitespaceAroundOperator": true,
  "powershell.codeFormatting.whitespaceAfterSeparator": true,
  "powershell.codeFormatting.ignoreOneLineBlock": true,
  "powershell.codeFormatting.alignPropertyValuePairs": true,
}
```
## File Header
All PowerShell files should include a file header. You can use teh Plaster templates provided in the project to generate the files for Functions Classes and Enums.

## Variable Naming
All variable names should be Pascal Case. This includes local variables, parameters, function nouns, method names, property names, field names, etc.

## Function Naming
Functions should use proper `Verb-Noun` names even on private functions and only use [Approved Verbs](https://msdn.microsoft.com/en-us/library/ms714428(v=vs.85).aspx). 

## Splatting
Use at-splatting whenever a command has 3 or more parameters. Use the `$Params` variable for splatting. If you need to splat more than one command in a pipeline use `$Params<command name>` (e.g. `$ParamsGetContent` ) for each command in the pipeline.

```powershell
# Single command
$Params = @{
    Name = 'Widget1'
    Id = '5ABCD98727658'
    Type = 'Custom'
}
Get-Widget @Params

# Multi-command pipeline
$ParamsAddWidget = @{
    Name = 'Widget1'
    Id = '5ABCD98727658'
    Type = 'Custom'
}
$ParamsSetWidget = @{
    Height = 10
    Width = 20
    Depth = 3
}
Add-Widget @ParamsAddWidget | Set-Widget @ParamsSetWidget
```

## Aliases
Expand all aliases prior to a PR. No aliases are permitted, including `Sort`. The PSAnalyzer tests should detect this and issue a failure.

## In-code Documentation
Limit in-code comments and documentation. If you are using full command names and PowerShell best practices, the code should be fairly self-documenting. Only use comments when doing something that is out of the norm or obscure.

# Code Separation and File Naming
All functions (public and private), classes, and enums should be defined in separate files and organized according to their category. This project has the potential to have a very large code base so separation and organization of code needs to be maintained even at an early stage. Do not define more than one function, class, or enum per file. Do not create nested functions. The filename should match the function or enum name. Class filenames should be prepended with a 3 digit load order and a dash.

# Strive for 100% Code Coverage by Tests
This project strives to be as close to 100% code coverage as possible. If you are submitting a new function (public or private), the PR will not be merged until a unit test has been added that tests all available code paths for the function. The same goes for classes. Every method in a class must have a test that coves all code paths in that method. If you extend an existing class with a new method, please add a corresponding test to the class's unit test.


# Document as You Go
The documentation under the `/docs/` project folder in the GitHub Repo is the source of truth for all documentation.

The build system in this project provides many auto-documentation features and many changes in code will be automatically reflected in the documentation. However, it is still important to go back and modify the documentation. Please update all documentation prior to making a pull request. PRs with help test failures will not be merged until they are corrected. 

Currently, the auto-documentation does not automatically add new methods, properties, constructors, and fields for classes and enums. Adding new methods, properties, constructors, and fields to classes or enums will required the necessary documentation be added to the relaxant `about_` topic.

I realize documentation is the boring part of coding, but it is a necessary evil and not something that can be thrown over the wall unless we gain some dedicated documentation contributors. the only way to keep this project properly documented is to do it as we go and not after the fact.

# Changes To the Build System
If you wish to make submissions to modify any of the code under the `/BuildTools/` project folder, please enable AppVeyor for your project and test that the project builds both locally and on appveyor. If you make changes to the secure variables in `AppVeyor.yml`, please revert them before your PR.

# Submitting Pull Requests
When you fork the project, please do so from the `Staging` branch. All pull requests should be made against the `Staging` branch. Ensure your last commit message does not have `[ci skip]`, `[skip ci]`, or `[skip appveyor]` so that the automated PR tests can run. Only PRs from the Staging branch will be accepted into Master. Please include a bullet list of the changes you made and to what functions, classes, enums, build tools, tests, or documentation.

