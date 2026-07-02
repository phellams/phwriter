---
layout: default
title: CLI Routing
nav_order: 4
description: "How to scaffold command line interfaces with subcommands using New-PHRouter."
---

# CLI Routing

PHWriter provides a lightweight router helper `New-PHRouter` (aliased as `phroute`) to build command-line tools with complex subcommand hierarchies and built-in help.

## Example CLI Entrypoint

```powershell
function Invoke-MyCli {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Args
    )

    $Routes = @{
        'build'   = { param($Remaining) Write-Host "Building project..." }
        'test'    = { param($Remaining) Invoke-Pester }
        'default' = { Write-Host "Usage: mycli <build|test>" }
    }

    New-PHRouter -Routes $Routes -Args $Args
}
```

## Fuzzy Command Matching

If the user types a command that doesn't match exactly, the routing engine calculates Levenshtein distances and recommends the closest subcommand automatically.
