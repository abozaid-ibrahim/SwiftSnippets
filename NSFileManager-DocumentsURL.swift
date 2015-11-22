/*---
id: 81654727-5834-4BB3-9EFA-D8A993FC2939
title: NSFileManager Documents Directory URL
summary: NSFileManager method to retrieve document directory
platform: All
completion-scopes: Function or Method
shortcut: nsfmdd
version: 1
---*/

guard let documentsDirectoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first else { <#code#> }