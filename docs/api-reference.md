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
             [-SourceType <String>] [-Theme <String|Hashtable>] [-Layout <String>] 
             [-CustomLogo <String>] [-Gradient] [-CustomGradient <Int[]>] 
             [-OuterBorder] [-BorderGradient] [-BorderCustomGradient <Int[]>]
             [-JsonFile <String>] [-OutMode <String>]
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
| `-OuterBorder` | Switch | — | Wraps layout in an outer border frame. |
| `-BorderGradient` | Switch | — | Gradient shader for the outer border. |
| `-BorderCustomGradient` | Int[] | — | Custom border gradient stops. |
| `-JsonFile` | String | — | Path to a `.json` configuration file. |
| `-OutMode` | String | `'Auto'` | Render mode: `Standard` (stdout), `Alt` (pager), `String` (returns text), or `Auto`. |

---

## 2. Show-PHTheme

DX utility to preview theme combinations directly in the shell.

### Syntax
```powershell
Show-PHTheme [-Name <String>] [-Layout <String>] [-All] [-Minimal] [-Compact] 
             [-Gradient] [-CustomGradient <Int[]>] [-OuterBorder] [-BorderGradient] 
             [-BorderCustomGradient <Int[]>] [-SourceType <String>] [-TextSpacing]
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
| `-OuterBorder` | Switch | — | Renders border frame outline. |
| `-BorderGradient` | Switch | — | Gradient shader for border frame. |
| `-BorderCustomGradient` | Int[] | — | Custom border gradient stops. |
| `-SourceType` | String | `'module'` | Header layout category parameter. |
| `-TextSpacing` | Switch | — | Adjust spacing layout density. |

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

---

## 4. Invoke-PHPager (Alias: `phpager`)

Renders text streams in an interactive TUI paging container.

### Syntax
```powershell
Invoke-PHPager [-Content] <String[]> [-Title <String>] [-Theme <String>] [-NoColor]
```

### Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `-Content` | String[] | *(Mandatory)* | Array of strings representing screen pages. |
| `-Title` | String | `'PH Pager'` | Title text displayed in the header chrome. |
| `-Theme` | String | `'phwriter'` | Style theme applied to border and footer controls. |
| `-NoColor` | Switch | — | Disables ANSI coloring sequences. |

---

## 5. New-PHRouter (Alias: `phroute`)

Configures CLI subcommand dispatching and fuzzy recommendations.

### Syntax
```powershell
New-PHRouter [-Routes] <Hashtable> [-ArgumentList] <String[]> [-ModuleName <String>]
             [-RegisterCompleter] [-Theme <String>]
```

### Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `-Routes` | Hashtable | *(Mandatory)* | Subcommand mapping: name (string) ➔ scriptblock or function name. |
| `-ArgumentList` | String[] | *(Mandatory)* | Arguments list to process (typically `$args`). |
| `-ModuleName` | String | `'PHRouter'` | CLI name used in error prompts. |
| `-RegisterCompleter` | Switch | — | Auto-registers argument tab completion. |
| `-Theme` | String | `'phwriter'` | Theme applied to error message recommendations. |

---

## 6. Write-PHAsciiLogo

Renders the themed ASCII logo banner alone.

### Syntax
```powershell
Write-PHAsciiLogo [-Name] <String> [-Layout <String>] [-Theme <String>] [-Version <String>]
                  [-Gradient] [-CustomGradient <Int[]>]
```

---

## 7. Get-TerminalPalette (Alias: `terpal`)

Helper to compile dynamic palette color maps.

### Syntax
```powershell
Get-TerminalPalette [-ColorMode] <String> [-GradientStart <Int[]>] [-GradientEnd <Int[]>]
                    [-ConditionalColors <Hashtable>]
```
