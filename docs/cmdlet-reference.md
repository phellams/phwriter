---
layout: default
title: Cmdlet Reference
nav_order: 4
description: "Complete usage examples and code patterns for all PHWriter public cmdlets."
has_toc: true
---

# Cmdlet Reference

Complete usage examples for all PHWriter public cmdlets. Each section covers the primary use-case, pipeline integration, common option combinations, and real-world patterns.

---

## New-PHWriter

Renders ANSI-formatted terminal help output directly to the console or an interactive pager.

### Minimal invocation

```powershell
# pwsh — module must be imported first
Import-Module PHWriter

$commandInfo = @{
    cmdlet      = 'Get-SystemData'
    synopsis    = 'Get-SystemData [-Path <String>] [-Force]'
    description = 'Retrieves operating system configuration data from the specified path.'
    source      = 'https://gitlab.com/example/systemtools'
}

$paramTable = @(
    @{ name = 'Path';  param = 'p|Path';  type = 'String'; required = $true;  description = 'Path to the configuration directory.'; inline = $false },
    @{ name = 'Force'; param = 'f|Force'; type = 'Switch'; required = $false; description = 'Suppress confirmation prompts.';        inline = $true  }
)

New-PHWriter -Name 'SystemTools' -Version '2.1.0' -CommandInfo $commandInfo -ParamTable $paramTable -Theme 'aurora'
```

### Pipeline input from Export-PHWriterMetadata

```powershell
# Pipe AST-extracted metadata directly — no manual hashtable required.
Export-PHWriterMetadata -Path ./Public/Get-SystemData.ps1 -FunctionName 'Get-SystemData' |
    New-PHWriter -Theme 'cyberpunk' -OuterBorder -Layout 'Terminal'
```

### Global config — set theme once for the session

```powershell
# Priority: explicit -Theme > global config > built-in default 'phwriter'
$global:__phwriter = @{
    theme_config = @{
        theme       = 'aurora'
        gradient    = $true
        outerborder = $true
        layout      = 'Box'
        # Override individual theme keys — AccentColor merged into resolved theme
        AccentColor = '201'
    }
}

# All subsequent New-PHWriter calls in this session inherit the global config.
Export-PHWriterMetadata -Path ./Public/My-Cmdlet.ps1 | New-PHWriter
```

### Param-level focused lookup with -HelpParam

```powershell
# Render only the -Theme parameter row; all other parameters suppressed.
Export-PHWriterMetadata -Path ./Public/New-PHWriter.ps1 -FunctionName 'New-PHWriter' |
    New-PHWriter -Theme 'phwriter' -HelpParam 'Theme' -OutMode 'Standard'
```

### Gradient header with outer border

```powershell
New-PHWriter `
    -Name        'MyCLI' `
    -Version     '1.0.0' `
    -CommandInfo $commandInfo `
    -ParamTable  $paramTable `
    -Theme       'neon-noir' `
    -Layout      'Terminal' `
    -Gradient `
    -OuterBorder `
    -BorderGradient `
    -OuterBorderStyle 'Double' `
    -OutMode     'Standard'
```

### Load from JSON file

```powershell
# Serialize metadata to JSON and load at runtime — useful for pre-built docs bundles.
Export-PHWriterMetadata -Path ./Public/Get-SystemData.ps1 -OutputJson ./libs/help/get-systemdata.json

New-PHWriter -JsonFile './libs/help/get-systemdata.json' -Theme 'matrix'
```

### Router layout — document CLI subcommands

```powershell
$subcommands = @(
    @{ name = 'build';  syntax = 'build [-Release]';        description = 'Compile the project.' },
    @{ name = 'test';   syntax = 'test [-Coverage]';         description = 'Execute the test suite.' },
    @{ name = 'deploy'; syntax = 'deploy -Env <String>';     description = 'Deploy to target environment.' }
)

New-PHWriter -Name 'mycli' -SourceType 'router' -Subcommands $subcommands -Theme 'phwriter' -OutMode 'Standard'
```

---

## Show-PHTheme

Renders a mock help page for any built-in theme, enabling visual comparison before committing to a theme in production code.

### Preview a single theme

```powershell
Show-PHTheme -Name 'aurora'
```

### Preview with gradient header and double border

```powershell
Show-PHTheme -Name 'cyberpunk' -Gradient -OuterBorder -BorderGradient -OuterBorderStyle 'Double'
```

### Preview all 50 themes sequentially in compact mode

```powershell
Show-PHTheme -All -Compact -Layout 'Minimal'
```

### Pipeline — preview a set of named themes

```powershell
'aurora', 'neon-noir', 'matrix', 'cosmic', 'phwriter' | Show-PHTheme -OuterBorder -Compact
```

### Use the shldc alias

```powershell
# shldc is the registered short alias for Show-PHTheme.
shldc -Name 'drift-blue-orange' -Gradient -OuterBorder -BorderGradient -Layout 'Terminal'
```

### Focused parameter lookup via -HelpParam

```powershell
# Show only parameters whose name or alias matches 'grad'.
Show-PHTheme -Name 'phwriter' -HelpParam 'grad'
```

---

## Export-PHWriterMetadata

Parses a `.ps1` or `.psm1` file using the PowerShell AST engine and extracts all function definitions, parameter blocks, CBH help, and syntax automatically.

### Extract a single function

```powershell
Export-PHWriterMetadata -Path './Public/Get-SystemData.ps1' -FunctionName 'Get-SystemData'
```

### Extract and serialize to JSON

```powershell
Export-PHWriterMetadata `
    -Path       './Public/Get-SystemData.ps1' `
    -OutputJson './libs/help_metadata/get-systemdata.json' `
    -Source     'https://gitlab.com/example/systemtools'
```

### Batch extract all public cmdlets

```powershell
Get-ChildItem -Path ./Public/*.ps1 | ForEach-Object {
    Export-PHWriterMetadata `
        -Path       $_.FullName `
        -OutputJson "./libs/help_metadata/$($_.BaseName).json"
}
```

### Pipe directly to New-PHWriter

```powershell
# No intermediate variables required.
Export-PHWriterMetadata -Path ./Public/Invoke-Deploy.ps1 -FunctionName 'Invoke-Deploy' |
    New-PHWriter -Theme 'steel-plate' -OuterBorder -OuterBorderStyle 'Square'
```

### Override module name and version

```powershell
Export-PHWriterMetadata `
    -Path       './Public/Invoke-Deploy.ps1' `
    -ModuleName 'DeployTools' `
    -Version    '3.0.0' `
    -Source     'https://internal.docs/deploytools'
```

### Inspect the returned metadata object

```powershell
$meta = Export-PHWriterMetadata -Path './Public/Get-SystemData.ps1'

# Enumerate extracted parameters
$meta.paramtable | Format-Table name, type, required
```

---

## Invoke-PHPager

Displays pre-formatted content in a full-screen, scrollable TUI paging view with keyboard navigation.

### Display a string in the pager

```powershell
$content = New-PHWriter -Name 'MyCLI' -CommandInfo $commandInfo -ParamTable $paramTable -Theme 'phwriter' -OutMode 'String'
Invoke-PHPager -Content $content -Title 'MyCLI Help'
```

### Pipe file content

```powershell
Get-Content './README.md' | Invoke-PHPager -Title 'README'
```

### Use the phpager alias with a custom theme

```powershell
$text = Export-PHWriterMetadata -Path ./Public/Get-SystemData.ps1 |
        New-PHWriter -Theme 'matrix' -OutMode 'String'

phpager -Content $text -Title 'Get-SystemData' -Theme 'matrix'
```

### Keyboard controls reference

| Key | Action |
|---|---|
| `u` / `d` | Scroll up / down one line |
| `PgUp` / `PgDn` | Scroll up / down one page |
| `Home` / `End` | Jump to first / last line |
| `l` / `r` | Horizontal scroll left / right |
| `q` / `ESC` | Exit pager |

---

## New-PHRouter

Dispatches CLI subcommands from a route map hashtable. Includes fuzzy match suggestions, tab-completion registration, and optional metadata-driven help.

### Basic dispatch

```powershell
function Invoke-MyCLI {
    param([string]$Mode, [string[]]$Args)

    $Routes = @{
        build  = { param($a) Write-Host "Building... args: $a" }
        test   = { param($a) Write-Host "Testing..."           }
        default = {
            New-PHWriter -Name 'mycli' -SourceType 'router' -Subcommands $subcommands -Theme 'phwriter' -OutMode 'Standard'
        }
    }

    New-PHRouter -Routes $Routes -ArgumentList $Args -ModuleName 'Invoke-MyCLI'
}
```

### Register tab-completion

```powershell
$Routes = @{ build = {}; test = {}; deploy = {}; default = {} }

# Registers tab-completion for the 'mycli' command in the current session.
New-PHRouter -Routes $Routes -ArgumentList @() -ModuleName 'mycli' -RegisterCompleter
```

### Full router entrypoint pattern

```powershell
function Invoke-FetchTvdb {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]$Mode,

        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Args
    )

    $subcommandsList = @(
        @{ name = 'search';      syntax = 'search <query>';         description = 'Search the TVDB catalogue by series title.' },
        @{ name = 'get-series';  syntax = 'get-series <id>';        description = 'Retrieve full series metadata by TVDB ID.'   },
        @{ name = 'get-episodes';syntax = 'get-episodes <id>';      description = 'Retrieve episode list for a series.'         },
        @{ name = 'export-data'; syntax = 'export-data <id> -Path'; description = 'Export series metadata to JSON or CSV.'      }
    )

    $CommandInfo = @{
        cmdlet      = 'Invoke-FetchTvdb'
        synopsis    = 'Invoke-FetchTvdb -Mode <String> [<Args>]'
        description = 'CLI client for the TVDB REST API.'
        source      = 'https://gitlab.com/phellams/fetchtvdb'
    }

    $Routes = @{
        'search'       = { param($a) Search-TvdbSeries -Query $a[0] }
        'get-series'   = { param($a) Get-TvdbSeries    -Id    $a[0] }
        'get-episodes' = { param($a) Get-TvdbEpisodes  -Id    $a[0] }
        default        = {
            New-PHWriter -Name 'FetchTVDB' -Version '1.0.0' `
                -CommandInfo $CommandInfo -Subcommands $subcommandsList `
                -Theme 'phwriter' -SourceType 'router' -OutMode 'Standard'
        }
    }

    $routerArgs = @()
    if ($Mode) { $routerArgs += $Mode }
    if ($Args)  { $routerArgs += $Args  }

    New-PHRouter -Routes $Routes -ArgumentList $routerArgs -ModuleName 'Invoke-FetchTvdb' -Theme 'phwriter'
}
```

---

## Write-PHAsciiLogo

Renders only the ASCII banner header — without the parameter table or sections. Useful for splash screens and custom help entrypoints.

### Render a named banner

```powershell
Write-PHAsciiLogo -Name 'MYCLI' -Version '2.0.0' -Theme 'aurora'
```

### Gradient banner with vertical mode

```powershell
Write-PHAsciiLogo -Name 'DEPLOY' -Version '1.0.0' -Theme 'neon-noir' -Layout 'Terminal' -Gradient -GradientMode 'Vertical'
```

### All six layout styles compared

```powershell
foreach ($layout in @('Box', 'Classic', 'Minimal', 'Man', 'Terminal', 'Typewriter')) {
    Write-PHAsciiLogo -Name 'DEMO' -Version '1.0.0' -Theme 'phwriter' -Layout $layout
    Start-Sleep -Milliseconds 800
}
```

### Custom ASCII logo string

```powershell
$logo = @'
 ____  _   _
|  _ \| | | |
| |_) | |_| |
|____/ \__, |
        __/ |
       |___/
'@

Write-PHAsciiLogo -Name 'MYAPP' -Version '0.1.0' -Theme 'cyberpunk' -CustomLogo $logo
```

---

## Get-TerminalPalette

Generates a dynamic color lookup object for use in themed TUI components. Supports solid, conditional threshold, and linear gradient modes.

### Solid palette

```powershell
$palette = Get-TerminalPalette -ColorMode 'Solid' -ColorPalette @{
    primary   = 'cyan'
    secondary = 'darkgray'
    accent    = '201'
    error     = 'red'
}

# Use resolved colors in ANSI output:
Write-Host "$([char]27)[38;5;$($palette.accent)mAccent text$([char]27)[0m"
```

### Conditional threshold palette

```powershell
# Returns a color from the map based on the CurrentValue relative to thresholds.
$palette = Get-TerminalPalette `
    -ColorMode        'Conditional' `
    -ColorThresholds  @{ 25 = 'green'; 75 = 'yellow'; 100 = 'red' } `
    -CurrentValue     60 `
    -MaxValue         100
```

### Gradient palette

```powershell
# Returns an interpolated color between Start and End based on CurrentValue / MaxValue.
$palette = Get-TerminalPalette `
    -ColorMode     'Gradient' `
    -GradientStart @(0, 200, 255) `
    -GradientEnd   @(255, 0, 150) `
    -CurrentValue  40 `
    -MaxValue      100
```

---

## New-AsciiTokenGradient

Applies TrueColor RGB gradient coloring to multi-line ASCII art. Uses a 2D flood-fill tokenizer to identify connected character shapes and maps gradient stops across them.

### Horizontal gradient on ASCII art

```powershell
$art = @(
    ' ██████╗ ██╗  ██╗',
    '██╔════╝ ██║  ██║',
    '██║      ███████║',
    '██║      ██╔══██║',
    '╚██████╗ ██║  ██║',
    ' ╚═════╝ ╚═╝  ╚═╝'
)

New-AsciiTokenGradient -Lines $art -StartColor @(0, 200, 255) -EndColor @(255, 0, 150) -Mode 'Horizontal'
```

### Vertical gradient

```powershell
New-AsciiTokenGradient -Lines $art -StartColor @(0, 255, 128) -EndColor @(128, 0, 255) -Mode 'Vertical'
```

### Per-token gradient (each disconnected shape independently colored)

```powershell
New-AsciiTokenGradient -Lines $art -StartColor @(255, 200, 0) -EndColor @(255, 50, 0) -Mode 'PerToken'
```

### Integration with Write-PHAsciiLogo

```powershell
# Custom logo rendered with full TrueColor gradient via token gradient engine.
$logo = @(
    '██████╗ ██╗  ██╗██╗    ██╗',
    '██╔══██╗██║  ██║██║    ██║',
    '██████╔╝███████║██║ █╗ ██║',
    '██╔═══╝ ██╔══██║██║███╗██║',
    '██║     ██║  ██║╚███╔███╔╝',
    '╚═╝     ╚═╝  ╚═╝ ╚══╝╚══╝ '
)

$gradientLogo = New-AsciiTokenGradient -Lines $logo -StartColor @(0,180,255) -EndColor @(255,0,180) -Mode 'Horizontal'
Write-PHAsciiLogo -Name 'PHW' -Version '1.0.0' -Theme 'phwriter' -CustomLogo ($gradientLogo -join "`n")
```
