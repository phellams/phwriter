---
layout: splash
title: Home
nav_order: 1
description: "PHWriter is an advanced formatted, ANSI-coloured terminal help output generator for PowerShell."
permalink: /
has_toc: true
---

## Interactive Terminal Preview (VHS Demo)

Below is a live-rendered visualization of a PHWriter CLI help screen using the **aurora** gradient theme and outer borders:

![PHWriter Terminal Preview](./assets/images/aurora.gif)

<div style="background-color: #171b21; border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 6px; box-shadow: 0 10px 30px rgba(0,0,0,0.5); font-family: 'JetBrains Mono', monospace; padding: 15px; margin: 20px 0; overflow: hidden; color: #f8f8f2;">
  <div style="border-bottom: 1px solid rgba(255,255,255,0.05); padding-bottom: 8px; margin-bottom: 10px; display: flex; align-items: center; justify-content: space-between;">
    <div style="display: flex; gap: 6px;">
      <span style="display: inline-block; width: 12px; height: 12px; border-radius: 50%; background-color: #ff5f56;"></span>
      <span style="display: inline-block; width: 12px; height: 12px; border-radius: 50%; background-color: #ffbd2e;"></span>
      <span style="display: inline-block; width: 12px; height: 12px; border-radius: 50%; background-color: #27c93f;"></span>
    </div>
    <span style="color: #6272a4; font-size: 13px;">pwsh — Show-PHTheme -Name 'aurora'</span>
    <span></span>
  </div>
  <pre style="margin: 0; background: none; border: none; box-shadow: none; color: #f8f8f2; font-size: 13px; line-height: 1.4;"><span style="color: #ff9f1a; font-weight: bold;">PS &gt; Show-PHTheme -Name 'aurora' -Gradient -OuterBorder -BorderGradient</span>

<span style="color: #bd93f9; font-weight: bold;">╭──────────────────────────────────────────────────────────╮</span>
<span style="color: #bd93f9; font-weight: bold;">│</span>                       <span style="color: #ff79c6; font-weight: bold;">S A M P L E</span>                        <span style="color: #bd93f9; font-weight: bold;">│</span>
<span style="color: #bd93f9; font-weight: bold;">╰──────────────────────────────────────────────────────────╯</span>

   <span style="background-color: #44475a; color: #8be9fd; font-weight: bold; padding: 1px 6px; border-radius: 3px;">CLI</span>   SAMPLE  <span style="color: #bd93f9;">◈</span>  <span style="background-color: #44475a; color: #50fa7b; font-weight: bold; padding: 1px 6px; border-radius: 3px;">FUNCTION</span>   Get-SampleCmdlet  <span style="color: #bd93f9;">◈</span>  <span style="background-color: #44475a; color: #ff79c6; font-weight: bold; padding: 1px 6px; border-radius: 3px;">VERSION</span>   v1.0.0 

  <span style="color: #50fa7b; font-weight: bold;">◈ SYNTAX</span>
    Get-SampleCmdlet [-Path &lt;String&gt;] [-Force] [-Verbose]

  <span style="color: #50fa7b; font-weight: bold;">◈ DESCRIPTION</span>
    This sample cmdlet retrieves configuration data and performs basic
    validation checks. It is formatted to show the colors and layouts of
    the theme.

  <span style="color: #50fa7b; font-weight: bold;">◈ PARAMETERS</span>
     -p|Path    [String]   Path (Req)
        Specifies the filesystem path to the target config file.

     -f|Force   [Switch]   Force
        Force the operation to complete without prompting.

  <span style="color: #50fa7b; font-weight: bold;">◈ EXAMPLES</span>
      Get-SampleCmdlet -Path 'config.json' -Force

      Get-SampleCmdlet -Path '/etc/app/config.json' -Verbose

   <span style="color: #ffb86c; font-weight: bold;">★ Docs: https://gitlab.com/phellams/phwriter for more info</span>
  </pre>
</div>

---

## Feature Overview

* 🎨 **41 Predefined Themes** — Vibrant, gradient-aware, or solid retro styles matching your project's brand.
* 📦 **AST Metadata Extraction** — Zero-touch parsing of comment-based help blocks directly from source files.
* 📟 **Interactive TUI Pager** — Alt-buffer terminal scrolling supporting custom width and console resize recalculation.
* 🚏 **CLI Router Scaffolding** — Subcommand dispatching with fuzzy Levenshtein recommendations and auto-completion.
* 🔖 **Tag-Padded Headers** — Modern tag blocks for clean, high-impact version metadata.

---

## Quick Start

Initialize, render, and page help details in seconds:

```powershell
# Import the module
Import-Module PHWriter

# Render the built-in theme preview
Show-PHTheme -Name 'phwriter'

# Generate documentation with a specific theme and compact layout
New-PHWriter @MyMetadata -Theme 'cyberpunk' -Compact
```

---

## Learning More

Use the sidebar navigation to read deep-dives on individual features, or explore:
* ➔ **[API Reference](api-reference.md)** — Fully documented parameters and syntax for all cmdlets.
* ➔ **[Installation & Downloads](downloads.md)** — PowerShell Gallery, Chocolatey, and release assets.
