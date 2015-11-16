/*---
id: 766D2740-688B-4944-9B6D-4BCD87221FF1
title: NSLayoutConstraint Initialiser
summary: NSLayoutConstraint initialiser snippet
platform: All
completion-scopes: Code Expression
shortcut: nslc
version: 1
---*/

let <#constraintName#> = NSLayoutConstraint(item: <#viewOne#>,
    attribute: <#NSLayoutAttribute#>,
    relatedBy: <#NSLayoutRelation#>,
    toItem: <#viewTwo#>,
    attribute: <#NSLayoutAttribute#>,
    multiplier: <#CGFloat#>,
    constant: <#CGFloat#>)

<#parentView#>.addConstraint(<#constraintName#>)