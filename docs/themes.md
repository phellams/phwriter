---
layout: default
title: Themes & Customization
nav_order: 5
description: "Predefined themes and how to build custom theme configurations."
---

# Themes & Customization

PHWriter features 41 built-in themes spanning three distinct categories.

![Themes Demo](./assets/images/all-themes-compact.gif)

---

## 1. Base Themes (10)

These use solid 16-color or 256-color palettes designed for maximum compatibility across various terminal emulators.

| Theme | Character | Style Description |
|---|---|---|
{% for theme in site.data.themes.base_themes -%}
| `{{ theme.name }}` | `{{ theme.symbol }}` | {{ theme.style }} |
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

These utilize advanced ASCII characters and unique color steps.

| Theme | Symbol (Sect/Head) | Gradient Stops | Description |
|---|---|---|---|
{% for theme in site.data.themes.extended_themes -%}
| `{{ theme.name }}` | `{{ theme.symbol }}` | `{{ theme.stops }}` | {{ theme.desc }} |
{% endfor %}

---

## 4. Custom Theme Configurations

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
