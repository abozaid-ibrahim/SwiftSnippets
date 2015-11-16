/*---
id: 95B462B4-D563-4E10-8CF3-FEA10902E854
title: Main Queue Processing
summary: Perform work on main queue
platform: All
completion-scope: Function or Method
shortcut: mainq
version: 1
---*/

dispatch_async(dispatch_get_main_queue()) { () -> Void in
    <#code#>
}