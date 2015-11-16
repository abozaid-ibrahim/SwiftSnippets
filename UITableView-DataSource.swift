/*---
id: D819481B-536C-4257-B3D7-5874A5B49685
title: UITableViewDataSource Extension
summary: Boilerplate methods for UITableViewDataSource Protocol
platform: iOS
completion-scope: Class Implementation
shortcut: tvds
version: 1
---*/

extension <#Class#> : UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        <#code#>
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        <#code#>
    }
    
}