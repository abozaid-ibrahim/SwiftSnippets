/*---
id: 33E78882-80F0-461D-85F3-A4853E4315F8
title: Asynchronous Background Processing
summary: Perform work on background queue and return results on main
platform: All
completion-scope: Function or Method
shortcut: async
version: 1
---*/

dispatch_async(dispatch_get_global_queue(<#T##identifier: Int##Int#>, 0)) { [weak self] () -> Void in
    <#code#>
    
    dispatch_async(dispatch_get_main_queue()) { () -> Void in
        <#code#>
    }
}