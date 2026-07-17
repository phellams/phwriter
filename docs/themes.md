---
layout: default
title: Themes & Customization
nav_order: 7
description: "Predefined themes and how to build custom theme configurations."
---

# Themes & Customization

PHWriter features 50 built-in themes spanning four categories.

![Themes Demo](./assets/images/all-themes-compact.gif)

---

## 1. Base Themes (10)

These use solid 16-color or 256-color palettes designed for maximum compatibility across various terminal emulators.

| Theme | Style Description |
|---|---|
{% for theme in site.data.themes.base_themes -%}
| `{{ theme.name }}` | {{ theme.style }} |
{% endfor %}

---

## 2. Gradient Themes (10)

These themes declare specific gradient steps and color ramps.

| Theme | Palette Stops | Accent Color |
|---|---|---|
{% for theme in site.data.themes.gradient_themes -%}
| `{{ theme.name }}` | `{{ theme.stops }}` | {{ theme.direction }} |
{% endfor %}

---

## 3. Extended Themes (20)

These use additional colour ramps and terminal-defined presentation characters.
The website deliberately does not reproduce those characters: they are decorative terminal output and their appearance varies with the installed terminal font.

| Theme | Gradient Stops | Description |
|---|---|---|
{% for theme in site.data.themes.extended_themes -%}
| `{{ theme.name }}` | `{{ theme.stops }}` | {{ theme.desc }} |
{% endfor %}

---

## 4. Hard-Bordered Themes (10)

These themes combine distinct border treatments with their colour configurations.

| Theme | Description |
|---|---|
{% for theme in site.data.themes.hard_bordered_themes -%}
| `{{ theme.name }}` | {{ theme.desc }} |
{% endfor %}

---

## 5. Theme Variants

Every selectable theme has Base, Rounded, Double, and Gradient VHS previews. Browse the [Theme Variant Gallery](theme-variant-gallery.html) to inspect the generated output and copy the corresponding `New-PHWriter` command.

---

## 6. Custom Theme Configurations

You can define a custom theme by passing a hashtable containing the layout color and formatting variables:

```powershell
$CustomTheme = @{
    AccentColor      = 'yellow'
    AccentFormat     = 'bold'
    BorderColor      = 'darkgray'
    BorderFormat     = 'none'
    HeaderFg         = 'white'
    SyntaxFg         = 'white'
    DescriptionFg    = 'white'
    ParamNameFg      = 'cyan'
    ParamTypeFg      = 'darkcyan'
    ParamReqFg       = 'red'
    ParamReqFormat   = 'bold'
    ParamDescFg      = 'gray'
    ExampleFg        = 'yellow'
    DocsFg           = 'cyan'
    SectionChar      = '◆'
    HeaderChar       = '»'
    BorderTop        = '┌────────────────────────────────────────────────────────┐'
    BorderBottom     = '└────────────────────────────────────────────────────────┘'
    BorderMiddle     = ' '
}

New-PHWriter -Name 'MyModule' -Theme $CustomTheme
```
