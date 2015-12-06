/*---
id: 7CC53565-E981-4737-B69F-87808AB4C463
title: CoreData Count FetchRequest
summary: Boilerplate Count NSFetchRequest
platform: iOS
completion-scopes: Code Expression
shortcut: cdc
version: 1
---*/

let fetchRequest = NSFetchRequest(entityName: <#T##String#>)
var error: NSError? = nil
let fetchedEntityCount = managedObjectContext.countForFetchRequest(fetchRequest, error: &error)
if let unwrappedError = error {
    print(unwrappedError.description)
} else {
    print("Total objects: \(fetchedEntityCount)")
}