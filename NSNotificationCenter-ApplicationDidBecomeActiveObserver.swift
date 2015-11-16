/*---
id: 2916CEE7-2E53-4099-AC32-B8783E4D107E
title: UIApplicationDidBecomeActiveNotification Observer
summary: Add notification center observer for UIApplicationDidBecomeActiveNotification
platform: All
completion-scope: Code Expression
shortcut: oadba
version: 1
---*/

NSNotificationCenter.defaultCenter().addObserver(self, selector: "<#selector#>", name: UIApplicationDidBecomeActiveNotification, object: nil)