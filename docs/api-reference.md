---
layout: default
title: API Reference
nav_order: 4
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
             [-SourceType <String>] [-Theme <String|Hashtable>] [-Layout <String>] 
             [-CustomLogo <String>] [-Gradient] [-CustomGradient <Int[]>] 
             [-GradientMode <String>] [-OuterBorder] [-BorderGradient]
             [-BorderCustomGradient <Int[]>] [-OuterBorderStyle <String>]
             [-Width <Object>] [-JsonFile <String>] [-OutMode <String>]
             [-KeepOutput] [-Help]
```

### Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `-Name` | String | `'PHW'` | Module, script, or tool name displayed in the banner. |
| `-CommandInfo` | Hashtable | — | Contains `cmdlet`, `synopsis`, `description`, and `source` URL keys. |
| `-ParamTable` | Hashtable[] | — | Array of parameters defining names, types, mandatory flags, and descriptions. |
| `-Subcommands` | Hashtable[] | — | Array of router subcommands for router layouts. |
| `-Examples` | String[] | — | Array of sample usage commands. |
| `-Version` | String | `'1.0.0'` | Version number string. |
| `-Padding` | Int | `3` | Columns layout spacing. |
| `-Indent` | Int | `1` | Left padding offset. |
| `-LineSpacing` | Int | `1` | Empty lines between parameters (`0`=compact, `1`=default, `2`=spacious). |
| `-Compact` | Switch | — | Convenience switch for `-LineSpacing 0`. |
| `-SourceType` | String | `'module'` | Layout header label: `module`, `script`, `tool`, `plugin`, `cli`, `function`, or `workflow`. |
| `-Theme` | String\|Hashtable | `'phwriter'` | Target theme name or custom theme hashtable. |
| `-Layout` | String | `'Box'` | ASCII title layout style: `Box`, `Classic`, `Minimal`, `Man`, `Terminal`, `Typewriter`. |
| `-CustomLogo` | String | — | Overrides logo with custom ASCII text. |
| `-Gradient` | Switch | — | Enables title gradient shading. |
| `-CustomGradient` | Int[] | — | Custom gradient color-index stops. |
| `-GradientMode` | String | `'Horizontal'` | Gradient distribution: `Horizontal`, `Vertical`, or `PerToken`. |
| `-OuterBorder` | Switch | — | Wraps layout in an outer border frame. |
| `-BorderGradient` | Switch | — | Gradient shader for the outer border. |
| `-BorderCustomGradient` | Int[] | — | Custom border gradient stops. |
| `-OuterBorderStyle` | String | `'Rounded'` | Border glyph set: `Rounded`, `Square`, `Double`, `Block`, or `Simple`. |
| `-Width` | Object | `'full'` | `full`, `man`, or a custom column width. |
| `-JsonFile` | String | — | Path to a `.json` configuration file. |
| `-OutMode` | String | `'Auto'` | Render mode: `Standard` (stdout), `Alt` (pager), `String` (returns text), or `Auto`. |
| `-KeepOutput` | Switch | Enabled | Keeps pager output in the standard buffer after exit. |
| `-Help` | Switch | — | Renders PHWriter-formatted command help. |

---

## 2. Show-PHTheme

DX utility to preview theme combinations directly in the shell.

### Syntax
```powershell
Show-PHTheme [-Name <String>] [-Layout <String>] [-All] [-Minimal] [-Compact] 
             [-Gradient] [-CustomGradient <Int[]>] [-OuterBorder] [-BorderGradient] 
             [-BorderCustomGradient <Int[]>] [-GradientMode <String>]
             [-SourceType <String>] [-TextSpacing] [-OuterBorderStyle <String>] [-Help]
```

### Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `-Name` | String | `'phwriter'` | Theme name to preview, or `'all'`, or `'custom-rgb'`. |
| `-Layout` | String | `'Box'` | Title layout preview style. |
| `-All` | Switch | — | Previews all 50 built-in themes sequentially. |
| `-Minimal` | Switch | — | Skips description/parameters; renders header title only. |
| `-Compact` | Switch | — | Shortcut for compact parameter line spacing. |
| `-Gradient` | Switch | — | Preview header gradient. |
| `-CustomGradient` | Int[] | — | Custom gradient stops. |
| `-GradientMode` | String | `'Horizontal'` | Gradient distribution: `Horizontal`, `Vertical`, or `PerToken`. |
| `-OuterBorder` | Switch | — | Renders border frame outline. |
| `-BorderGradient` | Switch | — | Gradient shader for border frame. |
| `-BorderCustomGradient` | Int[] | — | Custom border gradient stops. |
| `-SourceType` | String | `'module'` | Header layout category parameter. |
| `-TextSpacing` | Switch | — | Adjust spacing layout density. |
| `-OuterBorderStyle` | String | `'Rounded'` | Border glyph set for `-OuterBorder`. |
| `-Help` | Switch | — | Renders PHWriter-formatted command help. |

---

## 3. Export-PHWriterMetadata (Alias: `phextract`)

Statically parses `.ps1`/`.psm1` source code using the AST parser to compile documentation metadata.

### Syntax
```powershell
Export-PHWriterMetadata [-Path] <String> [-FunctionName <String>] [-OutputJson <String>]
                        [-ModuleName <String>] [-Version <String>] [-Source <String>]
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
| `-Help` | Switch | — | Renders PHWriter-formatted command help. |

---

## 4. Invoke-PHPager (Alias: `phpager`)

Renders text streams in an interactive TUI paging container.

### Syntax
```powershell
Invoke-PHPager [-Content] <String[]> [-Title <String>] [-PageSize <Int>] [-NoColor]
               [-Theme <String|Hashtable>] [-OnResize <ScriptBlock>] [-KeepOutput] [-Help]
```

### Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `-Content` | String[] | *(Mandatory)* | Array of strings representing screen pages. |
| `-Title` | String | `'PH Pager'` | Title text displayed in the header chrome. |
| `-PageSize` | Int | Console height | Optional number of visible content rows. |
| `-Theme` | String | `'phwriter'` | Style theme applied to border and footer controls. |
| `-NoColor` | Switch | — | Disables ANSI coloring sequences. |
| `-OnResize` | ScriptBlock | — | Callback invoked when console dimensions change. |
| `-KeepOutput` | Switch | Enabled | Keeps the rendered page in the standard buffer after exit. |
| `-Help` | Switch | — | Renders PHWriter-formatted command help. |

---

## 5. New-PHRouter (Alias: `phroute`)

Configures CLI subcommand dispatching and fuzzy recommendations.

### Syntax
```powershell
New-PHRouter [-Routes] <Hashtable> [-ArgumentList <String[]>] [-ModuleName <String>]
             [-RegisterCompleter] [-Metadata <Object>] [-Theme <String|Hashtable>] [-Help]
```

### Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `-Routes` | Hashtable | *(Mandatory)* | Subcommand mapping: name (string) ➔ scriptblock or function name. |
| `-ArgumentList` | String[] | Current argument list | Arguments list to process (typically `$args`). |
| `-ModuleName` | String | `'PHRouter'` | CLI name used in error prompts. |
| `-RegisterCompleter` | Switch | — | Auto-registers argument tab completion. |
| `-Metadata` | Object | — | Optional PHWriter metadata used for router help. |
| `-Theme` | String | `'phwriter'` | Theme applied to error message recommendations. |
| `-Help` | Switch | — | Renders PHWriter-formatted command help. |

---

## 6. Write-PHAsciiLogo

Renders the themed ASCII logo banner alone.

### Syntax
```powershell
Write-PHAsciiLogo [-Name] <String> [-Layout <String>] [-Theme <String>] [-Version <String>]
                  [-Gradient] [-CustomGradient <Int[]>] [-GradientMode <String>] [-Help]
```

---

## 7. Get-TerminalPalette (Aliases: `terpal`, `Get-TerminalPallete`)

Helper to compile dynamic palette color maps.

### Syntax
```powershell
Get-TerminalPalette [-ColorMode] <String> [-GradientStart <Int[]>] [-GradientEnd <Int[]>]
                    [-ColorPalette <Hashtable>] [-ColorThresholds <Hashtable>]
                    [-CurrentValue <Int>] [-MaxValue <Int>]

### Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `-ColorPalette` | Hashtable | — | Static named colour map. |
| `-ColorMode` | String | — | `Solid`, `Conditional`, or `Gradient`. |
| `-ColorThresholds` | Hashtable | — | Threshold-to-colour map for conditional mode. |
| `-GradientStart` | Int[] | — | RGB start triplet. |
| `-GradientEnd` | Int[] | — | RGB end triplet. |
| `-CurrentValue` | Int | `0` | Value evaluated in conditional mode. |
| `-MaxValue` | Int | `100` | Upper bound used by callers. |

---

## 8. New-AsciiTokenGradient

Applies a colour gradient per glyph position or connected ASCII-art token.

```powershell
New-AsciiTokenGradient [-Lines] <String[]> [-StartColor <Object>] [-EndColor <Object>]
                       [-Mode <String>] [-Connectivity <Int>]
```

| Parameter | Type | Default | Description |
|---|---|---|---|
| `-Lines` | String[] | *(Mandatory)* | ASCII-art lines accepted from the pipeline. |
| `-StartColor` | Object | `0,150,255` | Named colour or RGB triplet at the gradient start. |
| `-EndColor` | Object | `255,0,150` | Named colour or RGB triplet at the gradient end. |
| `-Mode` | String | `'Horizontal'` | `Horizontal`, `Vertical`, or `PerToken`. |
| `-Connectivity` | Int | `8` | Connected-component neighbourhood: `4` or `8`. |
```
