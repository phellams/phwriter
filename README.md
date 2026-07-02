<div align="center">

<img width="128" src="https://raw.githubusercontent.com/phellams/phellams-general-resources/main/logos/phwriter/dist/png/phwriter-logo-128x128.png" alt="PHWriter Logo" /> 

<h1><b>PHWriter</b></h1>

<a href="https://gitlab.com/phellams/phwriter/-/blob/main/readme.md"><img src="https://img.shields.io/badge/License-mit-License?style=flat-square&labelColor=%23383838&color=%237A5ACF23CD5C5C" alt="MIT License" /></a> <a href="https://gitlab.com/phellams/phwriter/-/pipelines"><img src="https://img.shields.io/gitlab/pipeline-status/phellams%2Fphwriter?style=flat-square&logo=Gitlab&logoColor=%233478BD&labelColor=%232D2D34" alt="Build Status"></a> <a href="https://codecov.io/gh/phellams/phwriter"><img src="https://img.shields.io/codecov/c/gitlab/phellams/phwriter?style=flat-square&logo=codecov&logoColor=%23E6746B&logoSize=auto&labelColor=%234A7A82" alt="Coverage"></a> <a href="https://gitlab.com/phellams/phwriter/-/issues"><img src="https://img.shields.io/gitlab/issues/open/phellams%2Fphwriter?style=flat-square&logo=gitlab&logoColor=red&labelColor=%23ffffff&color=%236B8D29" alt="Open Issues"></a>

</div>

---

## Overview

PHWriter (PowerShell Help Writer) is an enterprise-grade terminal help formatter for PowerShell modules and command-line interfaces. It generates beautifully formatted, ANSI-colored help outputs, simulating the look and structure of Linux man pages.

## Key Features

* ◈ **41 Built-in Themes** — Sleek color palettes including solid, gradient, and hard-bordered retro styles.
* ◈ **Padded Tags** — Header tags (like `CLI`, `FUNCTION`, `VERSION`) are rendered with tag-like padded spacing for clean aesthetics.
* ◈ **AST Metadata Extraction** — Static extraction of parameter names, aliases, and descriptions from cmdlet files.
* ◈ **Interactive TUI Pager** — Native terminal scrollable view supporting keyboard navigation and alternate buffer display.
* ◈ **CLI Routing Scaffold** — Dispatch command-line subcommands with built-in tab completion and fuzzy Levenshtein distance recommendations.

---

## Installation

```powershell
# Install from PowerShell Gallery
Install-Module -Name PHWriter -Scope CurrentUser

# Import directly from Source
git clone https://gitlab.com/phellams/phwriter.git
Import-Module ./phwriter/phwriter.psm1
```

---

## Quick Start

### 1. Rendering Help
Generate a beautiful help output with the default `phwriter` theme:
```powershell
Import-Module PHWriter
New-PHWriter -Name "MyModule" -Version "1.0.0" -Theme "phwriter"
```

### 2. Extracting Metadata Statically
Extract comment-based help and parameters from your script:
```powershell
$Meta = Export-PHWriterMetadata -FilePath "./Public/Get-MyData.ps1"
New-PHWriter @Meta
```

### 3. CLI Routing
Build a CLI command with subcommand routing:
```powershell
$Routes = @{
    'build'   = { param($Remaining) Write-Host "Compiling..." }
    'test'    = { param($Remaining) Invoke-Pester }
    'default' = { Write-Host "Usage: mycli <build|test>" }
}
New-PHRouter -Routes $Routes -ArgumentList $args -ModuleName 'mycli'
```

---

## Documentation Site

A comprehensive Jekyll documentation site is available under the `/docs` directory. 

* ➔ **[Jekyll Docs Site Home](file:///home/sgkens/devspace/projects/powershell/_repos/phwriter/docs/index.md)**
* ➔ **[Metadata Extraction Guide](file:///home/sgkens/devspace/projects/powershell/_repos/phwriter/docs/metadata-extraction.md)**
* ➔ **[Interactive TUI Pager](file:///home/sgkens/devspace/projects/powershell/_repos/phwriter/docs/tui-pager.md)**
* ➔ **[CLI Routing Guide](file:///home/sgkens/devspace/projects/powershell/_repos/phwriter/docs/cli-routing.md)**
* ➔ **[Themes & Customization](file:///home/sgkens/devspace/projects/powershell/_repos/phwriter/docs/themes.md)**

---

## Building and Testing

### Running Tests
To run Pester tests locally:
```powershell
pwsh -Command "Invoke-Pester ./test/test-unit-pester.ps1"
```

### Building the Project
To clean, build, and package the module locally:
```powershell
./automator-devops/localbuilder.ps1 -Build -pester
```

---

## License

MIT — see [LICENSE](./LICENSE) for details.