# <img width="46" src="https://raw.githubusercontent.com/phellams/phellams-general-resources/main/logos/phwriter/dist/png/phwriter-logo-128x128.png" alt="Phellams Logo" /> **PHWriter**

<a href="https://gitlab.com/phellams/phwriter/-/blob/main/readme.md"><img src="https://img.shields.io/badge/License-_mit-License?style=flat-square&labelColor=%23383838&color=%237A5ACF23CD5C5C" alt="MIT License" /></a>
<a href="https://gitlab.com/phellams/phwriter/-/pipelines"><img src="https://img.shields.io/gitlab/pipeline-status/phellams%2Fphwriter?style=flat-square&logo=Gitlab&logoColor=%233478BD&labelColor=%232D2D34" alt="Build Status"></a>
<a href="https://codecov.io/gh/phellams/phwriter"><img src="https://img.shields.io/codecov/c/gitlab/phellams/phwriter?style=flat-square&logo=codecov&logoColor=%23E6746B&logoSize=auto&labelColor=%234A7A82" alt="Build Status"></a>
<a href="https://gitlab.com/phellams/phwriter/-/issues"><img src="https://img.shields.io/gitlab/issues/open/phellams%2Fphwriter?style=flat-square&logo=gitlab&logoColor=red&labelColor=%23ffffff&color=%236B8D29" alt="gitlab issues"></a>

## Overview

PHWriter (**PowerShell Help Writer**) is a professional PowerShell module designed to generate beautifully formatted, colored help text for cmdlets and CLI tools, mimicking the style, layout, and readability of modern Linux man pages. It supports modular command architectures (standard cmdlets and router functions), visual layout templates, and swappable color theme palettes.

---

## High-Performance Architecture (phellams-aa Standards)

PHWriter is built from the ground up using strict **phellams-aa** system automation guidelines:
1. **Root Module Loader**: The main `phwriter.psm1` manages imports using high-performance .NET `[System.IO.Directory]` class bindings, dynamically dot-sourcing private helpers and public cmdlets while strictly controlling public exports via `Export-ModuleMember`.
2. **File-Per-Cmdlet**: Every cmdlet resides in its own isolated `.ps1` script file under the `/Public` directory (e.g. `New-PHWriter.ps1`, `Write-PHAsciiLogo.ps1`).
3. **Encapsulated Helpers**: Shared helper utilities reside under the `/Private` directory.
4. **The .NET First Rule**: Replaces slow PowerShell cmdlets with direct cross-platform .NET library calls (e.g. `[System.Text.StringBuilder]` for string building and `[System.IO.File]` for loading help configs).
5. **Color/Layout Exclusivity**: Utilizes a centralized ANSI 256-color parser that applies styling parameters *after* calculating layout padding to prevent character splitting and terminal output tearing.

---

## Installation

### Installation via PowerShell Gallery
```powershell
Install-Module -Name PHWriter -Scope CurrentUser
```

### Manual Installation
```bash
# Clone the repository
git clone https://gitlab.com/phellams/phwriter.git
cd phwriter
Import-Module .\phwriter.psm1
```

---

## Layout Templates

PHWriter features **6 distinct ASCII/ANSI banner layouts** for rendering module headers:

| Layout | Description | Visual Representation |
|---|---|---|
| `Box` | Renders the module name inside a sleek box with rounded corners. | `╭───...───╮` |
| `Classic` | Renders a retro, double-lined border with text filled in by a custom theme block character. | `╔═══...═══╗` |
| `Minimal` | Renders the spaced module name with a simple underlining bar. | `────...────` |
| `Man` | Mimics standard Linux manual headers at the top of the command console. | `PHW(1)  User Commands  PHW(1)` |
| `Terminal` | Renders a terminal prompt icon (`>_`) on the left, with details on the right. | `┌──┐ >_ Name` |
| `Typewriter` | Displays a detailed ANSI typewriter graphic on the left, with details on the right. | Typewriter glyph |

---

## The 10 Default Themes

PHWriter includes **10 built-in theme configurations** covering diverse visual aesthetics:

1. **`default`** (Retro Modern): Neon Cyan header and Module name over Dark Green section indicators and Gray meta tags.
2. **`matrix`** (Cyberpunk Green): High-contrast bright green on black. Perfect for dark terminal hacking setups.
3. **`cyberpunk`** (Neon Synthwave): Hot Pink accents, Neon Yellow descriptions, and Cyan parameter types.
4. **`dracula`** (Vampire Theme): Classic Dracula dark theme featuring Purple, Pink, Green, and Yellow highlights.
5. **`nord`** (Nordic Frost): Clean and calm palette with icy blues, cyan accents, and white text.
6. **Monokai** (`monokai`): Vibrant monokai theme utilizing pink, yellow, green, and orange text highlights.
7. **`solarized`** (Solarized Dark): Muted cyan and green highlight structure with soft blue parameter names.
8. **`sunset`** (Golden Hour): Warm reds, orange parameters, and golden yellow highlights.
9. **`forest`** (Natural Autumn): Forest green, olive green parameters, and gold accents.
10. **`classic`** (Old-School Man): Monochrome greyscale, mimicking traditional terminal man pages using only bold, underlines, and italics.

---

## Router Command Support

PHWriter can document **router functions**—commands that wrap around multiple subcommands (like `git` or `docker` subcommands). Using the `-Subcommands` array parameter, PHWriter generates a `SUBCOMMANDS` help section detailing the sub-features, syntax, and description of each router endpoint.

---

## Usage Guide

### Cmdlet Parameters

#### 🏮 `New-PHWriter`
Generates the help documentation layout:
- **`JsonFile`** (`[string]`): File path to a JSON configuration containing help definitions.
- **`Name`** (`[string]`): Name of the module/tool to display.
- **`CommandInfo`** (`[hashtable]`): Contains `cmdlet`, `synopsis`, `description`, and `source` URL.
- **`ParamTable`** (`[array]`): Array of hashtables representing cmdlet parameters (`name`, `param`, `type`, `required`, `description`, `inline`).
- **`Subcommands`** (`[array]`): Array of hashtables representing router subcommands (`name`, `syntax`, `description`).
- **`Examples`** (`[string[]]`): Array of example execution command blocks.
- **`Version`** (`[string]`): Version string. Default: `1.0.0`.
- **`Padding`** (`[int]`): Spaces between columns. Default: `3`.
- **`Indent`** (`[int]`): Spaces of left indentation. Default: `1`.
- **`Theme`** (`[string\|hashtable]`): Theme name (1 of the 10 defaults) or a custom theme hashtable. Default: `'default'`.
- **`Layout`** (`[string]`): Banner layout (`Box`, `Classic`, `Minimal`, `Man`, `Terminal`, `Typewriter`). Default: `'Box'`.
- **`CustomLogo`** (`[string]`): Custom ASCII logo art.

#### 🏮 `Write-PHAsciiLogo`
Outputs only the themed ASCII logo banner:
- **`Name`** (`[string]`): Name of the tool.
- **`Version`** (`[string]`): Tool version.
- **`Theme`** (`[string\|hashtable]`): Theme configuration.
- **`Layout`** (`[string]`): Layout name.

---

## Code Examples

### Standard Cmdlet Documentation

```powershell
$myCmdletParams = @(
    @{
        Name        = "SourcePath"
        Param       = "s|Source"
        Type        = "string"
        required    = $true
        Description = "Specifies the source path for the files. Wildcards supported."
        Inline      = $false
    },
    @{
        Name        = "Recurse"
        Param       = "r|Recurse"
        Type        = "switch"
        required    = $false
        Description = "Indicates that the operation should process recursively."
        Inline      = $true
    }
)

New-PHWriter -Name "MyModule" `
             -CommandInfo @{
                 cmdlet      = "Copy-Files"
                 synopsis    = "Copy-Files -SourcePath <string> [-Recurse]"
                 description = "Copies files from the source path to a predefined directory."
                 source      = "https://github.com/myuser/mymodule"
             } `
             -ParamTable $myCmdletParams `
             -Examples @(
                 "Copy-Files -SourcePath 'C:\source' -Recurse"
             ) `
             -Version "1.4.2" `
             -Theme "cyberpunk" `
             -Layout "Terminal"
```

### Router CLI Command Documentation

```powershell
$subcommands = @(
    @{
        Name        = "init"
        Syntax      = "init [-Force]"
        Description = "Initialize local Git repository configuration."
    },
    @{
        Name        = "commit"
        Syntax      = "commit -Message <string>"
        Description = "Record changes to the repository."
    }
)

New-PHWriter -Name "GitHelper" `
             -CommandInfo @{
                 cmdlet      = "git-helper"
                 synopsis    = "git-helper <command> [options]"
                 description = "A command router function providing simplified Git integrations."
                 source      = "https://gitlab.com/githelper"
             } `
             -Subcommands $subcommands `
             -Version "0.9.1" `
             -Theme "matrix" `
             -Layout "Classic"
```

### Defining a Custom Theme

You can pass a custom hashtable theme directly to `-Theme`:

```powershell
$myCustomTheme = @{
    AccentColor      = 'red'
    AccentFormat     = 'bold,underline'
    BorderColor      = 'yellow'
    BorderFormat     = 'none'
    HeaderBg         = 'black'
    HeaderFg         = 'white'
    ModuleBg         = 'black'
    ModuleFg         = 'red'
    VersionBg        = 'black'
    VersionFg        = 'yellow'
    SyntaxFg         = 'white'
    SyntaxFormat     = 'none'
    DescriptionFg    = 'white'
    ParamNameFg      = 'red'
    ParamNameFormat  = 'bold'
    ParamTypeFg      = 'yellow'
    ParamTypeFormat  = 'none'
    ParamReqFg       = 'red'
    ParamReqFormat   = 'bold'
    ParamDescFg      = 'gray'
    ExampleFg        = 'yellow'
    DocsFg           = 'red'
    DocsFormat       = 'underline'
    SectionChar      = '🔥'
    HeaderChar       = '➔'
    BorderTop        = '🔥━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━🔥'
    BorderBottom     = '🔥━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━🔥'
    BorderMiddle     = '░'
}

New-PHWriter -Name "FireCLI" -Theme $myCustomTheme -CommandInfo $commandInfo -ParamTable $params
```

---

## Contributing

1. Fork the Project.
2. Create your Feature Branch: `git switch -c feature/AmazingFeature`.
3. Commit your changes.
4. Push to the branch: `git push origin feature/AmazingFeature`.
5. Open a **Merge Request**.

## License

This project is licensed under the MIT License - see the LICENSE file for details.