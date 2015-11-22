/*---
id: 445AE21D-CC5E-4DA1-B588-E30B59ED94E2
title: CoreData Fetch Entity
summary: Boilerplate NSFetchRequest with Predicate and Sort Descriptor
platform: iOS
completion-scopes: Code Expression
shortcut: cdf
version: 1
---*/

let fetchRequest = NSFetchRequest(entityName: <#T##String#>)
fetchRequest.predicate = NSPredicate(format: <#T##String#>, argumentArray: <#T##[AnyObject]?#>)
let sortDescriptor = NSSortDescriptor(key: <#T##String?#>, ascending: <#T##Bool#>)
fetchRequest.sortDescriptors = [sortDescriptor]

let results: [<#Entity#>]
do {
    results = try context.executeFetchRequest(fetchRequest) as! [<#Entity#>]
} catch {
    print(error)
}