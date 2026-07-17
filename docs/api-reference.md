---
layout: default
title: API Reference
nav_order: 3
description: "Detailed parameter references and usage syntax for PHWriter public cmdlets."
has_toc: true
---

# API Reference

This page provides the comprehensive cmdlet API reference for PHWriter.

---

## Public Cmdlets Summary

| Cmdlet | Alias | Purpose / Description |
|---|---|---|
{% for cmdlet in site.data.cmdlets -%}
| `{{ cmdlet.name }}` | `{{ cmdlet.alias }}` | {{ cmdlet.purpose }} |
{% endfor %}

---

## 1. New-PHWriter

Generates the fully styled terminal help layouts.

### Syntax
```powershell
New-PHWriter [-Name <String>] [-CommandInfo <Hashtable>] [-ParamTable <Hashtable[]>] 
             [-Subcommands <Hashtable[]>] [-Examples <String[]>] [-Version <String>]
             [-Padding <Int>] [-Indent <Int>] [-LineSpacing <Int>] [-Compact] 
             [-SourceType <String>] [-Theme <Object>] [-Layout <String>] 
             [-CustomLogo <String>] [-Gradient] [-CustomGradient <Int[]>] 
             [-GradientMode <String>] [-OuterBorder] [-BorderGradient] 
             [-BorderCustomGradient <Int[]>] [-OuterBorderStyle <String>] 
             [-Width <Object>] [-JsonFile <String>] [-OutMode <String>] 
             [-KeepOutput] [-Help]
```

### Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `-JsonFile` | String | — | Path to a `.json` configuration file. |
| `-Name` | String | `'PHW'` | Module, script, or tool name displayed in the banner. |
| `-CommandInfo` | Hashtable | — | Contains `cmdlet`, `synopsis`, `description`, and `source` URL keys. |
| `-ParamTable` | Hashtable[] | — | Array of parameters defining names, types, mandatory flags, and descriptions. |
| `-Subcommands` | Hashtable[] | — | Array of router subcommands for router layouts. |
| `-Examples` | String[] | — | Array of sample usage commands. |
| `-Version` | String | — | Version number string. |
| `-Padding` | Int | `3` | Columns layout spacing. |
| `-Indent` | Int | `1` | Left padding offset. |
| `-LineSpacing` | Int | `1` | Empty lines between parameters (0=compact, 1=default, 2=spacious). |
| `-Compact` | Switch | — | Convenience switch for `-LineSpacing 0`. |
| `-SourceType` | String | `'module'` | Layout header label: module, script, tool, plugin, cli, function, workflow, or router. |
| `-Theme` | Object | `'phwriter'` | Target theme name or custom theme hashtable. |
| `-Layout` | String | `'Box'` | ASCII title layout style: Box, Classic, Minimal, Man, Terminal, Typewriter. |
| `-CustomLogo` | String | — | Overrides logo with custom ASCII text. |
| `-Gradient` | Switch | — | Enables title gradient shading. |
| `-CustomGradient` | Int[] | — | Custom gradient color-index stops. |
| `-GradientMode` | String | `'Horizontal'` | Gradient mode: Horizontal, Vertical, or PerToken. |
| `-OuterBorder` | Switch | — | Wraps layout in an outer border frame. |
| `-BorderGradient` | Switch | — | Gradient shader for the outer border. |
| `-BorderCustomGradient` | Int[] | — | Custom border gradient stops. |
| `-OuterBorderStyle` | String | `'Rounded'` | Corner style: Rounded, Square, Double, Block, Simple. |
| `-Width` | Object | `'full'` | Width in columns: 'man' (80), 'full' (console width), or a custom integer. |
| `-OutMode` | String | `'Auto'` | Render mode: Standard (stdout), Alt (pager), String (returns text), or Auto. |
| `-KeepOutput` | Switch | `$true` | Keeps help on stdout when exiting pager. |
| `-Help` | Switch | — | Displays help for New-PHWriter itself. |

---

## 2. Show-PHTheme

DX utility to preview theme combinations directly in the shell.

### Syntax
```powershell
Show-PHTheme [-Name <String>] [-Layout <String>] [-All] [-Minimal] [-Compact] 
             [-Gradient] [-CustomGradient <Int[]>] [-GradientMode <String>] 
             [-OuterBorder] [-BorderGradient] [-BorderCustomGradient <Int[]>] 
             [-OuterBorderStyle <String>] [-SourceType <String>] [-TextSpacing] [-Help]
```

### Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `-Name` | String | `'phwriter'` | Theme name to preview, or `'all'`, or `'custom-rgb'`. |
| `-Layout` | String | `'Box'` | Title layout preview style. |
| `-All` | Switch | — | Previews all 41 built-in themes sequentially. |
| `-Minimal` | Switch | — | Skips description/parameters; renders header title only. |
| `-Compact` | Switch | — | Shortcut for compact parameter line spacing. |
| `-Gradient` | Switch | — | Preview header gradient. |
| `-CustomGradient` | Int[] | — | Custom gradient stops. |
| `-GradientMode` | String | `'Horizontal'` | Gradient mode: Horizontal, Vertical, or PerToken. |
| `-OuterBorder` | Switch | — | Renders border frame outline. |
| `-BorderGradient` | Switch | — | Gradient shader for border frame. |
| `-BorderCustomGradient` | Int[] | — | Custom border gradient stops. |
| `-OuterBorderStyle` | String | `'Rounded'` | Corner style: Rounded, Square, Double, Block, Simple. |
| `-SourceType` | String | `'module'` | Header layout category parameter. |
| `-TextSpacing` | Switch | — | Adjust spacing layout density. |
| `-Help` | Switch | — | Displays help for Show-PHTheme itself. |

---

## 3. Export-PHWriterMetadata (Alias: `phextract`)

Statically parses `.ps1`/`.psm1` source code using the AST parser to compile documentation metadata.

### Syntax
```powershell
Export-PHWriterMetadata [-Path] <String> [-FunctionName <String>] [-OutputJson <String>]
                        [-ModuleName <String>] [-Version <String>] [-Source <String>] [-Help]
```

### Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `-Path` | String | *(Mandatory)* | Path to the PowerShell file. |
| `-FunctionName` | String | — | Restricts extraction to a specific function name. |
| `-OutputJson` | String | — | Serializes extracted metadata directly to a JSON file. |
| `-ModuleName` | String | — | Overrides module name in metadata. |
| `-Version` | String | `'1.0.0'` | Overrides version metadata. |
| `-Source` | String | — | Documentation link URL. |
| `-Help` | Switch | — | Displays help for Export-PHWriterMetadata itself. |

---

## 4. Invoke-PHPager (Alias: `phpager`)

Renders text streams in an interactive TUI paging container.

### Syntax
```powershell
Invoke-PHPager [-Content] <Object[]> [-Title <String>] [-PageSize <Int>] [-NoColor]
               [-Theme <Object>] [-OnResize <ScriptBlock>] [-KeepOutput] [-Help]
```

### Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `-Content` | Object[] | — | Content string(s) to display. |
| `-Title` | String | `'PHWriter Pager'` | Title text displayed in the header chrome. |
| `-PageSize` | Int | `0` | Height override in lines (0 for auto). |
| `-NoColor` | Switch | — | Disables ANSI coloring sequences. |
| `-Theme` | Object | `'phwriter'` | Theme applied to border and footer controls. |
| `-OnResize` | ScriptBlock | — | Callback executed on console resize. |
| `-KeepOutput` | Switch | `$true` | Keep output on stdout when pager exits. |
| `-Help` | Switch | — | Displays help for Invoke-PHPager itself. |

---

## 5. New-PHRouter (Alias: `phroute`)

Configures CLI subcommand dispatching and fuzzy recommendations.

### Syntax
```powershell
New-PHRouter [-Routes] <Hashtable> [-ArgumentList] <String[]> [-ModuleName <String>]
             [-RegisterCompleter] [-Metadata <Hashtable>] [-Help]
```

### Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `-Routes` | Hashtable | *(Mandatory)* | Subcommand mapping: name (string) ➔ scriptblock or function name. |
| `-ArgumentList` | String[] | *(Mandatory)* | Arguments list to process (typically `$args`). |
| `-ModuleName` | String | `'PHRouter'` | CLI name used in error prompts. |
| `-RegisterCompleter` | Switch | — | Auto-registers argument tab completion. |
| `-Metadata` | Hashtable | — | Optional PHWriter metadata hashtable for route verification. |
| `-Help` | Switch | — | Displays help for New-PHRouter itself. |

---

## 6. Write-PHAsciiLogo

Renders the themed ASCII logo banner alone.

### Syntax
```powershell
Write-PHAsciiLogo [-Name] <String> [-Layout <String>] [-Theme <Object>] [-Version <String>]
                  [-CustomLogo <String>] [-Gradient] [-CustomGradient <Int[]>]
                  [-GradientMode <String>] [-Help]
```

### Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `-Name` | String | — | The name of the module/tool to display. |
| `-Version` | String | `''` | Optional version string of the module. |
| `-Theme` | Object | `'phwriter'` | Theme name string or custom theme hashtable. |
| `-Layout` | String | `'Box'` | Title layout style: Box, Classic, Minimal, Man, Terminal, Typewriter. |
| `-CustomLogo` | String | — | Custom ASCII logo banner string. |
| `-Gradient` | Switch | — | Enables title gradient shading. |
| `-CustomGradient` | Int[] | — | Custom gradient color-index stops. |
| `-GradientMode` | String | `'Horizontal'` | Gradient mode: Horizontal, Vertical, or PerToken. |
| `-Help` | Switch | — | Displays help for Write-PHAsciiLogo itself. |

---

## 7. Get-TerminalPalette (Alias: `terpal`)

Helper to compile dynamic palette color maps.

### Syntax
```powershell
Get-TerminalPalette [-ColorPalette <Hashtable>] [-ColorMode <String>] 
                    [-ColorThresholds <Hashtable>] [-GradientStart <Int[]>] 
                    [-GradientEnd <Int[]>] [-CurrentValue <Int>] [-MaxValue <Int>]
```

### Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `-ColorPalette` | Hashtable | — | Static colors lookup hashtable. |
| `-ColorMode` | String | — | Palette mode: `'Solid'`, `'Conditional'`, or `'Gradient'`. |
| `-ColorThresholds` | Hashtable | — | Numeric threshold maps for Conditional mode. |
| `-GradientStart` | Int[] | — | RGB array [R, G, B] for starting gradient stop. |
| `-GradientEnd` | Int[] | — | RGB array [R, G, B] for ending gradient stop. |
| `-CurrentValue` | Int | — | Current value used in Conditional mode check. |
| `-MaxValue` | Int | `100` | Maximum limit for gradient/conditional maps. |

---

## 8. New-AsciiTokenGradient

Applies TrueColor gradients to ASCII art based on tokenized 2D shapes.

### Syntax
```powershell
New-AsciiTokenGradient [-Lines] <String[]> [[-StartColor] <Object>] [[-EndColor] <Object>]
                       [[-Mode] <String>] [-Connectivity <Int>]
```

### Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `-Lines` | String[] | *(Mandatory)* | The input string array representing the ASCII art to colorize. |
| `-StartColor` | Object | `0, 150, 255` | Starting color as an RGB array or a named color. |
| `-EndColor` | Object | `255, 0, 150` | Ending color as an RGB array or a named color. |
| `-Mode` | String | `'Horizontal'` | Gradient mapping mode: `'Horizontal'`, `'Vertical'`, or `'PerToken'`. |
| `-Connectivity` | Int | `8` | Connection connectivity (4 or 8) for shape detection. |
