# <img width="46" src="https://raw.githubusercontent.com/phellams/phellams-general-resources/main/logos/phwriter/dist/png/phwriter-logo-128x128.png" alt="PHWriter Logo" /> PHWriter

<a href="https://gitlab.com/phellams/phwriter/-/blob/main/readme.md"><img src="https://img.shields.io/badge/License-mit-License?style=flat-square&labelColor=%23383838&color=%237A5ACF23CD5C5C" alt="MIT License" /></a>
<a href="https://gitlab.com/phellams/phwriter/-/pipelines"><img src="https://img.shields.io/gitlab/pipeline-status/phellams%2Fphwriter?style=flat-square&logo=Gitlab&logoColor=%233478BD&labelColor=%232D2D34" alt="Build Status"></a>
<a href="https://codecov.io/gh/phellams/phwriter"><img src="https://img.shields.io/codecov/c/gitlab/phellams/phwriter?style=flat-square&logo=codecov&logoColor=%23E6746B&logoSize=auto&labelColor=%234A7A82" alt="Coverage"></a>
<a href="https://gitlab.com/phellams/phwriter/-/issues"><img src="https://img.shields.io/gitlab/issues/open/phellams%2Fphwriter?style=flat-square&logo=gitlab&logoColor=red&labelColor=%23ffffff&color=%236B8D29" alt="Open Issues"></a>

---

## Overview

**PHWriter** (PowerShell Help Writer) is a professional PowerShell module for generating beautifully formatted, ANSI-coloured terminal help output. It reproduces the clarity and structure of Linux man pages with modern, themeable aesthetics and a zero-boilerplate API.

Core capabilities:

- **20 built-in themes** — 10 flat-colour themes + 10 new gradient-aware themes
- **6 ASCII/ANSI banner layouts** — Box, Classic, Minimal, Man, Terminal, Typewriter
- **AST-powered zero-touch metadata extraction** — Parse cmdlet source files automatically
- **Interactive TUI pager** — Arrow-key navigation, alternate screen buffer, ANSI-aware
- **CLI router scaffold** — Subcommand dispatch, tab-completion, Levenshtein fuzzy matching
- **Module and script-file aware** — Detects `.psd1` manifests; adapts header label accordingly
- **Adjustable spacing and padding** — Compact to spacious output, developer-controlled

---

## Architecture (phellams-aa Standards)

PHWriter is structured to the [phellams-aa](https://gitlab.com/phellams/phwriter) engineering standard:

| Principle | Implementation |
|---|---|
| Root Module Loader | `phwriter.psm1` dot-sources via `[System.IO.Directory]::GetFiles()` |
| File-Per-Cmdlet | Each public cmdlet has its own `.ps1` in `/Public` |
| Encapsulated Helpers | All shared helpers live in `/Private` |
| .NET First | `[System.IO.*]`, `[System.Text.StringBuilder]`, `[System.Collections.Generic.List[T]]` throughout |
| Padding Rule | All string lengths computed **before** ANSI encoding — no screen tearing |

---

## Installation

```powershell
# PowerShell Gallery
Install-Module -Name PHWriter -Scope CurrentUser

# Manual
git clone https://gitlab.com/phellams/phwriter.git
Import-Module ./phwriter.psm1
```

---

## Public Cmdlets

| Cmdlet | Alias | Purpose |
|---|---|---|
| `New-PHWriter` | — | Render full help documentation |
| `Write-PHAsciiLogo` | — | Render the themed ASCII banner only |
| `Export-PHWriterMetadata` | `phextract` | Extract cmdlet metadata from source via AST |
| `Invoke-PHPager` | `phpager` | Display content in an interactive TUI pager |
| `New-PHRouter` | `phroute` | Dispatch CLI subcommands with tab-completion |

---

## New-PHWriter

### Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `-Name` | String | `'PHW'` | Module, script, or tool name displayed in the banner |
| `-CommandInfo` | Hashtable | — | `cmdlet`, `synopsis`, `description`, `source` keys |
| `-ParamTable` | Hashtable[] | — | Parameter definitions (see format below) |
| `-Subcommands` | Hashtable[] | — | Router subcommand definitions |
| `-Examples` | String[] | — | Usage example strings |
| `-Version` | String | `'1.0.0'` | Version string |
| `-Padding` | Int | `3` | Column padding in spaces |
| `-Indent` | Int | `1` | Left indentation in spaces |
| `-LineSpacing` | Int | `1` | Blank lines between parameter rows (`0`=compact, `1`=default, `2`=spacious) |
| `-SourceType` | String | `'module'` | Header label — `module`, `script`, `tool`, or `plugin` |
| `-Theme` | String\|Hashtable | `'default'` | Theme name or custom theme hashtable |
| `-Layout` | String | `'Box'` | Banner layout style |
| `-CustomLogo` | String | — | Override banner with a custom ASCII string |
| `-JsonFile` | String | — | Load all parameters from a JSON file |
| `-Help` | Switch | — | Display PHWriter's own help output |

### ParamTable Row Format

Each entry in `-ParamTable` is a hashtable with the following keys:

```powershell
@{
    name        = 'SourcePath'    # Parameter name (display only)
    param       = 's|SourcePath'  # Alias|FullName format — pipe-separated
    type        = 'String'        # Type string to display
    required    = $true           # Boolean — shows (Req) label when true
    description = 'The source path for input files.'
    inline      = $false          # $true = description on same line as name
                                  # $false = description on next line (default)
}
```

### Subcommands Row Format

```powershell
@{
    name        = 'build'
    syntax      = 'build [-Release] [-Target <String>]'
    description = 'Compile the project.'
}
```

### Examples

#### Standard cmdlet documentation

```powershell
$params = @(
    @{
        name        = 'SourcePath'
        param       = 's|SourcePath'
        type        = 'String'
        required    = $true
        description = 'Path to the source directory.'
        inline      = $false
    },
    @{
        name        = 'Recurse'
        param       = 'r|Recurse'
        type        = 'Switch'
        required    = $false
        description = 'Process subdirectories recursively.'
        inline      = $true
    }
)

New-PHWriter `
    -Name        'MyModule' `
    -Version     '2.1.0' `
    -Theme       'cyberpunk' `
    -Layout      'Terminal' `
    -LineSpacing 0 `
    -CommandInfo @{
        cmdlet      = 'Copy-Files'
        synopsis    = 'Copy-Files -SourcePath <String> [-Recurse]'
        description = 'Copies files from a source path to a predefined output directory.'
        source      = 'https://github.com/myuser/mymodule'
    } `
    -ParamTable  $params `
    -Examples    @('Copy-Files -SourcePath C:\src -Recurse')
```

#### Script-file documentation (not a module)

```powershell
New-PHWriter `
    -Name       'deploy.ps1' `
    -SourceType 'script' `
    -Version    '0.3.0' `
    -Theme      'nord' `
    -CommandInfo @{
        cmdlet      = 'Invoke-Deploy'
        synopsis    = 'Invoke-Deploy -Environment <String>'
        description = 'Deploys the application to a target environment.'
        source      = ''
    } `
    -ParamTable $params
```

#### Router function documentation

```powershell
$subcommands = @(
    @{ name='init';   syntax='init [-Force]';              description='Initialise the project.' },
    @{ name='build';  syntax='build [-Release]';           description='Compile the project.' },
    @{ name='test';   syntax='test [-Coverage] [-Filter]'; description='Run the test suite.' }
)

New-PHWriter `
    -Name        'mycli' `
    -Version     '1.0.0' `
    -Theme       'matrix' `
    -Layout      'Classic' `
    -Subcommands $subcommands `
    -CommandInfo @{
        cmdlet      = 'mycli'
        synopsis    = 'mycli <command> [options]'
        description = 'CLI entrypoint for the MyProject tool.'
        source      = 'https://gitlab.com/myuser/myproject'
    }
```

#### Compact layout (developer preference)

```powershell
# LineSpacing 0 = no blank lines between params — tight, compact output
New-PHWriter @meta -Theme 'steel' -Layout 'Minimal' -LineSpacing 0 -Padding 2
```

#### Spacious layout

```powershell
# LineSpacing 2 = two blank lines between params — airy, readable output
New-PHWriter @meta -Theme 'aurora' -Layout 'Box' -LineSpacing 2 -Padding 5
```

---

## Themes

### Base Themes (10)

| Theme | Character | Style |
|---|---|---|
| `default` | `◉` | Retro Modern — neon cyan/dark green |
| `matrix` | `$` | Cyberpunk Green — high-contrast bright green |
| `cyberpunk` | `▲` | Neon Synthwave — hot pink, yellow, cyan |
| `dracula` | `🧛` | Dracula Dark — purple, pink, green, yellow |
| `nord` | `❄` | Nordic Frost — icy blues and white |
| `monokai` | `❖` | Monokai — pink, yellow, green, orange |
| `solarized` | `☼` | Solarized Dark — muted cyan/green on dark |
| `sunset` | `🌅` | Golden Hour — reds, oranges, gold |
| `forest` | `🌲` | Natural Autumn — greens and gold |
| `classic` | ` ` | Old-School Man — monochrome, bold/underline |

### Gradient Themes (10)

These themes declare `GradientSteps` and `GradientType` keys. Use `New-AsciiGradient` to apply the gradient to text elements.

| Theme | Palette | Gradient Direction |
|---|---|---|
| `aurora` | Cyan → Purple → Magenta | `[51,93,129,201]` |
| `neon-noir` | Magenta → Deep Pink | `[201,198,196,200]` |
| `lava` | Red → Orange → Yellow | `[196,202,214,220]` |
| `ocean` | Dark Blue → Cyan | `[17,20,27,39,51]` |
| `toxic` | Acid Greens | `[46,82,118,154]` |
| `midnight` | Deep Indigo → Violet | `[17,54,91,128,165]` |
| `gold` | Dark Gold → Yellow | `[136,172,214,220,226]` |
| `rose` | Deep Pink → Light Pink | `[161,197,199,207,213]` |
| `steel` | Dark Grey → Light Grey | `[233,238,243,248,253]` |
| `phwriter` | Classic PHWriter retro | flat (no gradient) |

`phman` is an alias for `phwriter`.

### Extended Themes (20)

These 20 additional themes utilize advanced ASCII characters and unique color steps:

| Theme | Description | Symbol (Section/Header) | Gradient Stops |
|---|---|---|---|
| `glitch` | Cyberpunk Glitchy | `▚` / `▞` | `[196,201,45,51]` |
| `cosmic` | Space & Starry Night | `☄` / `★` | `[17,21,57,93,129]` |
| `forest-mist` | Moss Green / Earthy | `🍀` / `🌿` | `[22,28,64,106,244]` |
| `blood-moon` | Dark Vampire Red | `🥀` / `🩸` | `[232,52,88,124,160]` |
| `retro-arcade` | 80s Synthwave | `🕹` / `👾` | `[196,201,93,39]` |
| `abyss` | Deep Ocean Trench | `⦿` / `⁘` | `[232,17,18,19,21]` |
| `zen` | Minimalist Zen | `⛩` / `☯` | `[245,248,252,255]` |
| `blaze` | Intense Fire | `☄` / `🔥` | `[196,202,208,214,220]` |
| `rust` | Industrial Decay | `⚙` / `⚒` | `[52,94,130,166]` |
| `matrix-neon` | Vibrant Code Stream | `⁙` / `⁚` | `[22,28,34,40,46]` |
| `quantum` | Subatomic Scientific | `⬢` / `⬟` | `[57,93,129,81]` |
| `radioactive` | Toxic Nuclear Fallout | `☣` / `☢` | `[232,190,226,190]` |
| `vaporwave` | 80s Pink/Teal Palm | `🌴` / `🐬` | `[201,165,129,81,51]` |
| `nebula` | Deep Space Star Dust | `✹` / `✸` | `[129,135,163,199,201]` |
| `crystal` | Diamond & Glacier Ice | `❖` / `✧` | `[159,195,231,255]` |
| `copper` | Copper Pipeline / Orange | `╞` / `╡` | `[130,136,172,214]` |
| `royal` | Gold on Royal Blue | `⚜` / `✦` | `[17,20,21,220,226]` |
| `desert-heat` | Warm Sands & Sun | `☀` / `🏜` | `[130,166,202,214,220]` |
| `sheriff` | Western Brown / Leather | `✶` / `↱` | `[52,94,137,180]` |
| `frost` | Arctic Blizzard | `❄` / `❆` | `[240,244,248,117,159]` |

---

### Previewing Themes (DX)

PHWriter provides a built-in Developer Experience (DX) previewing tool `Show-PHTheme` to render themes directly in your terminal:

```powershell
# Preview a single theme in full layout mode
Show-PHTheme -Name 'cyberpunk'

# Preview all 41 themes in minimal banner mode
Show-PHTheme -All -Minimal -Layout 'Terminal'

# Preview a dynamic custom RGB theme
Show-PHTheme -Name 'custom-rgb' -Layout 'Classic'
```

---

### Applying a Gradient Theme

```powershell
$theme = Get-PHTheme -Name 'aurora'

# Apply the theme's declared gradient to a string
$gradientTitle = New-AsciiGradient `
    -Type   $theme.GradientType `
    -Steps  $theme.GradientSteps `
    -String 'AURORA MODULE' `
    -Format @('bold')

# Then use the theme for the rest of the layout
New-PHWriter @meta -Theme $theme
```

### Custom Theme

Any hashtable with the required keys is a valid theme:

```powershell
$myTheme = @{
    AccentColor     = 'red'
    AccentFormat    = 'bold,underline'
    BorderColor     = 'yellow'
    BorderFormat    = 'none'
    HeaderBg        = 'black'
    HeaderFg        = 'white'
    ModuleBg        = 'black'
    ModuleFg        = 'red'
    VersionBg       = 'black'
    VersionFg       = 'yellow'
    SyntaxFg        = 'white'
    SyntaxFormat    = 'none'
    DescriptionFg   = 'white'
    ParamNameFg     = 'red'
    ParamNameFormat = 'bold'
    ParamTypeFg     = 'yellow'
    ParamTypeFormat = 'none'
    ParamReqFg      = 'red'
    ParamReqFormat  = 'bold'
    ParamDescFg     = 'gray'
    ExampleFg       = 'yellow'
    DocsFg          = 'red'
    DocsFormat      = 'underline'
    SectionChar     = '>'
    HeaderChar      = ':'
    BorderTop       = '==================='
    BorderBottom    = '==================='
    BorderMiddle    = ' '
}

New-PHWriter -Theme $myTheme @rest
```

---

## Banner Layouts

| Layout | Description |
|---|---|
| `Box` | Rounded-corner box: `╭──...──╮` |
| `Classic` | Theme-defined border strings from `BorderTop`/`BorderBottom` |
| `Minimal` | Spaced name + underline bar |
| `Man` | Linux man-page header: `NAME(1)   User Commands   NAME(1)` |
| `Terminal` | Terminal icon glyph `>_` on left, name/version on right |
| `Typewriter` | Retro typewriter glyph on left, name/version on right |

---

## Export-PHWriterMetadata (phextract)

Zero-touch AST parser. Point at any `.ps1` or `.psm1` file — it returns a ready-to-use metadata hashtable consumable directly by `New-PHWriter`.

### Parameters

| Parameter | Type | Description |
|---|---|---|
| `-Path` | String (Mandatory) | Source `.ps1` or `.psm1` file. Accepts pipeline from `Get-ChildItem` |
| `-FunctionName` | String | Filter to a specific function name. Supports wildcards (`Get-*`) |
| `-OutputJson` | String | Serialize extracted metadata to a `.json` file |
| `-ModuleName` | String | Override module name in the output |
| `-Version` | String | Override version string. Default: `1.0.0` |
| `-Source` | String | Documentation URL to embed |

### Module vs Script Detection

`Export-PHWriterMetadata` automatically detects whether the source file is part of a module by walking up directory levels looking for a `.psd1` manifest (max 3 levels).

- **Module detected** — `ModuleName` and `ModuleVersion` are read from the manifest. The `sourcetype` key in the returned hashtable is set to `'module'`.
- **No manifest found** — The file basename is used as the name, and `sourcetype` is set to `'script'`.

Use the returned `sourcetype` value directly with `New-PHWriter -SourceType`:

```powershell
$meta = Export-PHWriterMetadata -Path './Public/Invoke-Deploy.ps1'
New-PHWriter @meta -SourceType $meta.sourcetype -Theme 'nord'
```

### What It Extracts

From comment-based help (`.SYNOPSIS`, `.DESCRIPTION`, `.PARAMETER`, `.EXAMPLE`) and the AST parameter block:

- Function name → `commandinfo.cmdlet`
- Parameter name, type, mandatory flag, aliases → `paramtable`
- `HelpMessage` attribute as description fallback
- `.EXAMPLE` code blocks → `examples`
- Module name and version from `.psd1` manifest

### CBH Format Requirements

For best extraction results, each function must have complete comment-based help **immediately before the `param()` block**, inside the function body:

```powershell
function Get-SystemData {
    <#
    .SYNOPSIS
      Returns system diagnostic data.
    .DESCRIPTION
      Collects CPU, memory, and disk statistics from the local machine.
    .PARAMETER ComputerName
      Target computer name or IP. Default: localhost.
    .PARAMETER IncludeDisk
      When specified, includes disk usage data.
    .EXAMPLE
      Get-SystemData -ComputerName SERVER01
    .EXAMPLE
      Get-SystemData -IncludeDisk
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, HelpMessage = 'Target computer.')]
        [string]$ComputerName = 'localhost',

        [Parameter(Mandatory = $false)]
        [switch]$IncludeDisk
    )
    ...
}
```

**Critical rules:**

1. `.SYNOPSIS` must be a single concise line — it is used as display text, not the syntax line (the syntax line is auto-generated from the AST).
2. `.PARAMETER <Name>` blocks are matched case-insensitively to parameter variable names.
3. If `.PARAMETER` is missing for a param, `HelpMessage` attribute value is used as the description fallback.
4. `.EXAMPLE` blocks: only the code portion is extracted (the line immediately after `.EXAMPLE`).
5. The `[CmdletBinding()]` attribute must be present for `GetHelpContent()` to resolve correctly.

### Multi-Cmdlet File Awareness

If a `.ps1` file contains multiple functions, use `-FunctionName` to target a specific one:

```powershell
# File contains: Get-Data, Set-Data, Remove-Data
$meta = Export-PHWriterMetadata -Path './Data.ps1' -FunctionName 'Get-Data'

# Wildcard — extract all Get-* functions
$metas = Export-PHWriterMetadata -Path './Data.ps1' -FunctionName 'Get-*'

# No filter — returns array of metadata for every function found
$all = Export-PHWriterMetadata -Path './Data.ps1'
```

### Batch Extraction

```powershell
# Extract all Public cmdlets and cache as JSON
Get-ChildItem -Path ./Public/*.ps1 | ForEach-Object {
    Export-PHWriterMetadata `
        -Path       $_.FullName `
        -OutputJson "./docs/metadata/$($_.BaseName).json" `
        -Source     'https://gitlab.com/myuser/mymodule'
}

# Load from JSON and render
New-PHWriter -JsonFile './docs/metadata/Get-SystemData.json' -Theme 'matrix'
```

---

## Invoke-PHPager (phpager)

An interactive TUI pager using the terminal's alternate screen buffer. Enters cleanly; exits cleanly without leaving output in the scroll buffer.

### Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `-Content` | String[] | — | Content to display. Pipeline-compatible |
| `-Title` | String | `'PHWriter Pager'` | Top bar title text |
| `-PageSize` | Int | auto | Override page height in lines |
| `-NoColor` | Switch | — | Strip ANSI codes before display |

### Keyboard Controls

| Key | Action |
|---|---|
| `↑` / `↓` | Scroll one line |
| `PgUp` / `PgDn` | Jump one page |
| `Home` / `End` | Jump to start / end |
| `Q` / `ESC` | Quit pager |

### Usage

```powershell
# Pipe Get-Help output into the pager
Get-Help Get-Process -Full | Out-String | Invoke-PHPager -Title 'Get-Process'

# Pipe New-PHWriter output into the pager
New-PHWriter @meta -Theme 'dracula' | Out-String | phpager -Title 'MyModule Docs'

# Plain text mode
Get-Content ./CHANGELOG.md | phpager -Title 'CHANGELOG' -NoColor
```

---

## New-PHRouter (phroute)

Zero-boilerplate CLI subcommand dispatcher with tab-completion registration and Levenshtein fuzzy "Did you mean?" on unknown subcommands.

### Parameters

| Parameter | Type | Description |
|---|---|---|
| `-Routes` | Hashtable (Mandatory) | Subcommand name → `[scriptblock]` or function name string |
| `-ArgumentList` | String[] | Raw argument array (typically `$args`) |
| `-ModuleName` | String | CLI name for error messages. Default: `'PHRouter'` |
| `-RegisterCompleter` | Switch | Auto-register `Register-ArgumentCompleter` for tab completion |
| `-Metadata` | Hashtable | PHWriter metadata for route validation |

### Route Map Format

```powershell
$routes = @{
    'build'   = { param($rest) Invoke-Build @rest }   # scriptblock
    'test'    = 'Invoke-PesterTests'                   # function name string
    'docs'    = {
        $meta = phextract ./Public/Invoke-MyCLI.ps1
        New-PHWriter @meta -Theme 'nord' | Out-String | phpager
    }
    'default' = { Write-Host "Usage: mycli <build|test|docs>" }
}
```

The `'default'` key is invoked when no subcommand is provided.

### Full CLI Entrypoint Example

```powershell
function Invoke-MyCLI {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromRemainingArguments)]
        [string[]]$args
    )

    $routes = @{
        'build'   = { param($rest) Invoke-Build @rest }
        'test'    = 'Invoke-PesterTests'
        'release' = { param($rest) Publish-Module @rest }
        'help'    = {
            $meta = phextract ./Public/Invoke-MyCLI.ps1
            New-PHWriter @meta -Theme 'default' | Out-String | phpager -Title 'MyCLI Help'
        }
        'default' = { Write-Host "Run: mycli help" }
    }

    New-PHRouter `
        -Routes            $routes `
        -ArgumentList      $args `
        -ModuleName        'mycli' `
        -RegisterCompleter
}
```

### Unknown Subcommand Output

```
Unknown subcommand: 'buid'

Did you mean?
  build

Available subcommands for mycli:
  build
  help
  release
  test
```

---

## Color and Gradient Helpers

These private helpers are used internally but can be accessed inside module scope.

### New-AsciiColor

Applies ANSI 256-color foreground/background and format codes to a string.

```powershell
# By name (16-color system)
New-AsciiColor -String 'Hello' -Color 'cyan' -Format 'bold'

# By 256-color index
New-AsciiColor -String 'Hello' -Color '51' -BgColor '235' -Format @('bold','underline')
```

**Available format values:** `bold`, `dim`, `italic`, `underline`, `blink`, `reverse`, `hidden`, `strikethrough`

### New-AsciiGradient

Applies an interpolated 256-color gradient across the characters of a string.

```powershell
# Cyan → Purple → Magenta gradient on foreground
New-AsciiGradient -Type fg -Steps @(51, 93, 129, 201) -String 'AURORA' -Format @('bold')

# Background gradient
New-AsciiGradient -Type bg -Steps @(196, 214, 226) -String 'LAVA'
```

### Get-TerminalPalette (Alias: terpal, Get-TerminalPallete)

Generates a dynamic terminal palette object supporting Solid, Conditional, or Gradient color modes with RGB, 256-color, or named color formats.

```powershell
# Create a dynamic RGB gradient palette
$gradientPal = Get-TerminalPalette `
    -ColorMode 'Gradient' `
    -GradientStart @(255, 0, 0) `
    -GradientEnd @(0, 0, 255)

# Apply dynamic colors to string characters
$testString = "Beautiful custom gradient!"
$chars = $testString.ToCharArray()
for ($i = 0; $i -lt $chars.Count; $i++) {
    $code = $gradientPal.GetFillColor.Invoke($i, $chars.Count)
    Write-Host -NoNewline ($gradientPal.Apply.Invoke($chars[$i], $code))
}
```

---

## JSON Configuration

All `New-PHWriter` parameters can be loaded from a JSON file. Useful for storing help definitions alongside source files.

```json
{
    "name": "MyModule",
    "version": "2.0.0",
    "theme": "cyberpunk",
    "layout": "Terminal",
    "linespacing": 1,
    "sourcetype": "module",
    "commandinfo": {
        "cmdlet": "Invoke-MyCommand",
        "synopsis": "Invoke-MyCommand -Target <String> [-Verbose]",
        "description": "Executes the primary workflow for MyModule.",
        "source": "https://gitlab.com/myuser/mymodule"
    },
    "paramtable": [
        {
            "name": "Target",
            "param": "t|Target",
            "type": "String",
            "required": true,
            "description": "Target resource identifier.",
            "inline": false
        }
    ],
    "examples": [
        "Invoke-MyCommand -Target 'production'",
        "Invoke-MyCommand -Target 'staging' -Verbose"
    ]
}
```

Load with:

```powershell
New-PHWriter -JsonFile './docs/metadata/mymodule.json'
```

---

## Integration with Build Pipeline

PHWriter is a first-class citizen in the phellams `automator-devops` build system. The `Phwriter` flag in `build_config.json` triggers automatic help generation during the build stage.

```json
{
    "Phwriter": true
}
```

The local build script (`automator-devops/localbuild.ps1`) handles module loading, metadata extraction, and help rendering automatically.

---

## Development Workflow

```
develop → feature/<name> → PR → develop → main (release)
```

Commit convention: [Conventional Commits](https://www.conventionalcommits.org/)

```bash
git switch -c feature/my-feature
# ... implement ...
git add Public/My-Feature.ps1
git commit -m "feat(phwriter): add My-Feature cmdlet"
git push origin feature/my-feature
```

---

## Contributing

1. Fork the repository.
2. Create a feature branch: `git switch -c feature/my-change`
3. Implement changes. Ensure Pester tests pass (`pester -Coverage 90%+`).
4. Open a Merge Request against `develop`.

---

## License

MIT — see [LICENSE](./LICENSE) for details.