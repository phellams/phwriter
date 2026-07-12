---
layout: splash
title: Home
nav_order: 1
description: "PHWriter is an advanced formatted, ANSI-coloured terminal help output generator for PowerShell."
permalink: /
has_toc: true
---

# PHWriter

PHWriter renders structured, themed command help for PowerShell modules and command-line tools.

## Interactive Terminal Preview

Below is a live-rendered visualization of a PHWriter CLI help screen using the **aurora** gradient theme and outer borders:

<img class="ph-demo-image" src="./assets/images/aurora.gif" width="848" height="480" alt="PHWriter terminal preview using the aurora theme">

<div class="ph-terminal" aria-label="Terminal command example">
  <div class="ph-terminal__titlebar"><span aria-hidden="true">● ● ●</span><span>pwsh — Show-PHTheme -Name 'aurora'</span></div>
  <pre><code>PS&gt; Show-PHTheme -Name 'aurora' -Gradient -OuterBorder -BorderGradient

╭──────────────────────────────────────────────────────────╮
│                       S A M P L E                        │
╰──────────────────────────────────────────────────────────╯</code></pre>
</div>

---

## Feature Overview

- **50 predefined themes** — vibrant, gradient-aware, or solid retro styles matching your project's brand.
- **AST metadata extraction** — zero-touch parsing of comment-based help blocks directly from source files.
- **Interactive TUI pager** — alt-buffer terminal scrolling supporting custom width and console resize recalculation.
- **CLI router scaffolding** — subcommand dispatching with fuzzy Levenshtein recommendations and auto-completion.
- **Tag-padded headers** — modern tag blocks for clean, high-impact version metadata.

## Explore Theme Families

<div class="ph-theme-families">
  <a class="ph-theme-family" href="themes.html#1-base-themes-10"><strong>Base</strong><span>Solid palettes for broad terminal compatibility.</span></a>
  <a class="ph-theme-family" href="themes.html#2-gradient-themes-10"><strong>Gradient</strong><span>Colour ramps for headers and borders.</span></a>
  <a class="ph-theme-family" href="themes.html#3-extended-themes-20"><strong>Extended</strong><span>Distinctive terminal presentations and colour steps.</span></a>
  <a class="ph-theme-family" href="themes.html#4-hard-bordered-themes-10"><strong>Hard-bordered</strong><span>Bold frames paired with focused colour treatments.</span></a>
</div>

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
