---
layout: default
title: Metadata Extraction
nav_order: 2
description: "How to use Export-PHWriterMetadata to extract cmdlet help content statically via AST."
---

# Metadata Extraction

PHWriter includes an AST-powered extraction engine called `Export-PHWriterMetadata` (aliased as `phextract`) that extracts parameters, descriptions, and syntax information from your PowerShell cmdlet files statically.

## Usage

```powershell
Export-PHWriterMetadata -Path "./Public/Get-MyData.ps1"
```

## How It Works

1. **AST Parsing**: The cmdlet parses the PowerShell script's Abstract Syntax Tree (AST).
2. **CBH Association**: It parses Comment-Based Help (CBH) blocks placed immediately preceding the `param(...)` block inside the function body.
3. **Module Detection**: It automatically walks up directory trees to find a `.psd1` manifest file, setting the `sourcetype` metadata to `module` or `script` accordingly.

## Placement Rules

To extract help comments correctly, place the comment block inside the function body, immediately before the parameter declarations:

```powershell
function Get-MyData {
    <#
    .SYNOPSIS
      Gets some data.
    .PARAMETER Path
      The path to check.
    #>
    param(
        [string]$Path
    )
}
```

## Smart Parameter Aliasing

To improve the terminal command-line user experience, `Export-PHWriterMetadata` automatically generates conflict-free short aliases for all cmdlet parameters during AST parsing.

### How It Resolves Aliases

1. **Length-1 Default**: It attempts to take the first character of the parameter name (e.g., `-p` for `-Path`).
2. **Conflict Checking**: It cross-checks the generated candidate alias against a blocked list:
   - **Common Parameters**: standard PowerShell common parameters (`Verbose`, `Debug`, `ErrorAction`, `WarningAction`, `InformationAction`, `ErrorVariable`, `WarningVariable`, `InformationVariable`, `OutVariable`, `OutBuffer`, `PipelineVariable`, `WhatIf`, `Confirm`, `UseTransaction`) and their standard short aliases (`vb`, `db`, `ea`, `wa`, `infa`, `ev`, `wv`, `infv`, `ov`, `ob`, `pv`).
   - **Other Cmdlet Parameters**: full parameter names defined on the function.
   - **Other Explicit Aliases**: any aliases explicitly declared on the cmdlet's other parameters.
   - **Previously Generated Aliases**: smart aliases assigned to preceding parameters.
3. **Length-N Expansion**: If a collision is detected, the engine increments the candidate length by 1 character (e.g., trying the first 2 characters, then 3, and so on) until a unique short alias is resolved.

The resolved smart alias is prepended to the parameter's alias list. This allows `New-PHWriter` to display them as primary shortcuts (e.g., `-p | -Path`) in the rendered help layouts.
