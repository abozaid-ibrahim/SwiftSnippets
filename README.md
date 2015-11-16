![Swift Snippets](https://raw.githubusercontent.com/ElliottFrench/PublicAssets/master/SwiftSnippetAssets/Banner.png)

___

#Swift Snippets


[![Language](https://img.shields.io/badge/Language-Swift_2-orange.svg)](https://developer.apple.com/swift) [![Build](https://img.shields.io/badge/Build-Passing-brightgreen.svg)]() [![License](https://img.shields.io/badge/License-MIT-blue.svg)]() [![Platforms](https://img.shields.io/badge/Platforms-iOS | OS X | tvOS | watchOS-lightgrey.svg)](https://developer.apple.com/)


A collection of useful Swift 2 snippets for various Apple platforms, including a simple installation script to generate and import snippets to Xcode.



## Installing and Updating Xcode Snippets
___

The included script will generate and install the required Xcode pLists for `.codesnippet` files. Simply follow the instructions below to begin.


1. Clone the repository in your Terminal: `git clone git@github.com:ElliottFrench/SwiftSnippets.git`
2. Navigate to the repository's 'script/' directory: `cd script/`
3. Run the `install.swift` script with one of two options:

    **Option 1:** Generate and install all snippets in **parent** directory: 
    `swift install.swift -all`

    **Option 2:** Install a specific snippet by supplying its file path like so:
    `swift install.swift /path/to/snippet.swift`
    
**IMPORTANT:** You will need to restart Xcode to see your updated snippets.

The script will notify you of any warnings or errors that occurred during execution and also indicate which snippets have been installed/ updated via their identifiers.

## Directory Structure
___

The installation script searches for `.swift` files in its **parent** directory. It ignores hidden files and does not traverse contained directories.


## Contributing Snippets
___

###Naming Conventions

To help identify snippet text files in the repository please follow this simple naming convention:

1. A prefix to describe the Class or Framework the snippet relates to;
2. A name that describes the code snippet itself;
3. A `.swift` file extension.

Example: `UITableView-Delegate.swift`

### Generating UUIDs

Each code snippet in Xcode is given a Universally Unique Identifier or UUID. In order for the `install.swift` script to update existing snippets a UUID must be supplied with the .swift snippet text file. By default, if an identifier isn't provided then the script will generate one for you, however, each time this script is executed a new snippet will be generated in Xcode, potentially creating duplicates. To prevent this behaviour, generate a UUID and include it as the value of the snippet `id` property.

You can generate UUIDs at: https://www.guidgenerator.com/ (for consistency please generate uppercase UUIDs).

###Example Snippet

Filename: `UITableView-Delegate.swift`
___

`/*---`
`id: E70E066D-0F92-48D9-92BB-367E738A560F`
`title: UITableViewDelegate Extension`
`summary: Boilerplate methods for UITableViewDelegate Protocol`
`platform: iOS`
`completion-scopes: Class Implementation`
`shortcut: tvdel`
`version: 1`
`---*/`

`...Valid Swift code `


## Accepted Snippet Properties

___

| Key               | Value (Type)                     | Default              |
| ----------------- | ---------------------------------| -------------------- |
| id                | UUID (`String`)                  | Newly generated UUID |
| title             | Snippet title (`String`)         | Empty String         |
| summary           | Snippet summary (`String`)       | Empty String         |
| platform          | One of the following options: **iOS, OSX, tvOS, watchOS, All** (`String`) | All         |
| completion-scopes | Comma separated list of _one or more_ completion-scopes: **Class Implementation, Code Expression, Function or Method, String or Comment, Top Level, All**  (`String`)    | All     |
| shortcut          | Snippet Shortcut (`String`)      | Empty String         |
| version           | Integer convertible string (`String`)   | 1             |

## Requirements
___

- Swift 2.0+
- Xcode 4.0+

## License
___

The MIT License (MIT) Copyright (c) 2015 Elliott French

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

