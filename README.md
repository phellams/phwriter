<div align="center">

<img width="128" src="https://raw.githubusercontent.com/phellams/phellams-general-resources/main/logos/phwriter/dist/png/phwriter-logo-128x128.png" alt="PHWriter Logo" /> 

<h1><b>Powershell Help Writer(PHWriter)</b></h1>

<a href="https://gitlab.com/phellams/phwriter/-/blob/main/readme.md"><img src="https://img.shields.io/badge/License-mit-License?style=flat-square&labelColor=%23383838&color=%237A5ACF23CD5C5C" alt="MIT License" /></a> <a href="https://gitlab.com/phellams/phwriter/-/pipelines"><img src="https://img.shields.io/gitlab/pipeline-status/phellams%2Fphwriter?style=flat-square&logo=Gitlab&logoColor=%233478BD&labelColor=%232D2D34" alt="Build Status"></a> <a href="https://codecov.io/gh/phellams/phwriter"><img src="https://img.shields.io/codecov/c/gitlab/phellams/phwriter?style=flat-square&logo=codecov&logoColor=%23E6746B&logoSize=auto&labelColor=%234A7A82" alt="Coverage"></a> <a href="https://gitlab.com/phellams/phwriter/-/issues"><img src="https://img.shields.io/gitlab/issues/open/phellams%2Fphwriter?style=flat-square&logo=gitlab&logoColor=red&labelColor=%23ffffff&color=%236B8D29" alt="Open Issues"></a>

<span>
    <a href="https://phellams.gitlab.io/phwriter">🧷 <strong>Docs</strong></a>
    <a href="https://www.powershellgallery.com/packages/PWSL">🧷 <strong>PSGallery</strong></a>
    <a href="https://chocolatey.org/packages/pwphwritersl">🧷 <strong>Chocolatey</strong></a>
    <a href="https://github.com/phellams/phwriter">🧷 <strong>GitHub</strong></a>
</span>

</div>

---

## Overview

PHWriter (**PowerShell Help Writer**) is modeled in insperation from linux man pages, allows manual or automatic help data json, psdatafiles, and AST parsing, support for themes including colors and and or borders, intelegiant color switching for supported terminals only supporting `3/4bit` and terminal that support full color spectecture, phwriter is performant by utilizing `C#` methods for string cancatination. automatic padding and sizing allowing auto scalling

## Module Features

* ◈ **41 Built-in Themes** — broad color palettes including solid, gradient, and hard-bordered retro styles.
* ◈ **Padded Tags** — Header tags (like `CLI`, `FUNCTION`, `VERSION`) are rendered with tag-like padded spacing for clean aesthetics.
* ◈ **AST Metadata Extraction** — Static extraction of parameter names, aliases, and descriptions from cmdlet files.
* ◈ **Interactive TUI Pager** — Native terminal scrollable view supporting keyboard navigation and alternate buffer display.
* ◈ **CLI Routing Scaffold** — Dispatch command-line subcommands with built-in tab completion and fuzzy Levenshtein distance recommendations.

---

## **Installation**

Phellams modules are available from [**PowerShell Gallery**](https://www.powershellgallery.com/packages/commitfusion) and [**Chocolatey**](https://chocolatey.org/packages/commitfusion). you can access the raw assets via [**Gitlab Generic Assets**](https://gitlab.com/phellams/commitfusion/-/packages?orderBy=name&sort=desc&search[]=commitfusion) or nuget repository via [**Gitlab Packages**](https://gitlab.com/phellams/commitfusion/-/packages/?orderBy=name&sort=desc&search[]=commitfusion&type=NuGet).

|▓▓▓▓▒▒▒▒░░░|▓▓▓▓▒▒▒▒░░░|▓▓▓▓▒▒▒▒░░░|
|-|-|-|
|📦 PSGallery | <a href="https://www.powershellgallery.com/packages/phwriter"> <img src="https://img.shields.io/powershellgallery/v/phwriter?label=version&style=flat-square&logoColor=blue&labelColor=23CD5C5C&color=%231E3D59" alt="powershellgallery"></a> | <img src="https://img.shields.io/powershellgallery/dt/phwriter?style=flat-square&logoColor=blue&label=downloads&labelColor=23CD5C5C&color=%231E3D59" alt="powershellgallery-downloads"> |
|📦 Chocolatey | <a href="https://community.chocolatey.org/packages/phwriter/"><img src="https://img.shields.io/chocolatey/v/phwriter?label=version&include_prereleases&style=flat-square&logoColor=blue&labelColor=23CD5C5C&color=%231E3D59" alt="chocolatey"/></a> | <img src="https://img.shields.io/chocolatey/dt/phwriter?style=flat-square&logoColor=blue&label=downloads&include_prereleases&labelColor=23CD5C5C&color=%231E3D59" alt="chocolatey-downloads"> |

### Additinonal Installation Options:
 
|▓▓▓▓▒▒▒▒░░░|▓▓▓▓▒▒▒▒░░░|▓▓▓▓▒▒▒▒░░░|
|-|-|-|
|💼 Releases/Tags | <a href="https://gitlab.com/phellams/phwriter/-/releases"> <img src="https://img.shields.io/gitlab/v/release/phellams%2Fphwriter?include_prereleases&style=flat-square&logoColor=%2300B2A9&labelColor=%23CD5C5C&color=%231E3D59" alt="gitlab-release"></a> | <a href="https://gitlab.com/phellams/phwriter/-/tags"> <img src="https://img.shields.io/gitlab/v/tag/phellams%2Fphwriter?include_prereleases&style=flat-square&logoColor=%&labelColor=%23CD5C5C&color=%231E3D59" alt="gitlab tags"></a> |

#### GitLab Packages

Using `nuget`: See the [**packages**](https://gitlab.com/phellams/phwriter/-/packages?orderBy=name&sort=asc&search[]=phwriter&type=NuGet) page for installation instructions.

> For instructions on adding `nuget` **sources** packages from *GitLab* see [**Releases**](https://github.com/sgkens/phwriter/releases) artifacts or via the [**Packages**](https://gitlab.com/phellams/phwriter/-/packages?orderBy=name&sort=asc&search[]=phwriter&type=NuGet) page.

#### Generic Asset

The latest release artifacts can be downloaded from the [**Generic Assets Artifacts**](https://gitlab.com/phellams/phwriter/-/packages?orderBy=type&sort=desc&type=Generic) page.

#### Git Clone

```bash
# Clone the repository
git clone https://gitlab.com/phellams/phwriter.git
cd phwriter
import-module .\
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
Extract comment-based help, parameters, and conflict-free smart parameter aliases from your script:
```powershell
$Meta = Export-PHWriterMetadata -Path "./Public/Get-MyData.ps1"
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

* ➔ **[Jekyll Docs Site Home](https://phellams.gitlab.io/phwriter)**
* ➔ **[Metadata Extraction Guide](https://phellams.gitlab.io/phwriter#metadata-extraction.md)**
* ➔ **[Interactive TUI Pager](https://phellams.gitlab.io/phwriter#tui-pager.md)**
* ➔ **[CLI Routing Guide](https://phellams.gitlab.io/phwriter#cli-routing.md)**
* ➔ **[Themes & Customization](https://phellams.gitlab.io/phwriter#docs/themes.md)**

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