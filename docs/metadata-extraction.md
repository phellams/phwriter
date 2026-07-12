---
layout: default
title: Metadata Extraction
nav_order: 3
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
