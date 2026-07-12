---
layout: default
title: Theme Variant Gallery
nav_order: 8
description: "Terminal previews of PHWriter border and gradient variants."
---

# Theme Variant Gallery

`Invoke-AllThemeVarients.ps1` renders each supported presentation variant for a selected built-in theme.

{% assign aurora_theme = site.data.themes.gradient_themes | where: 'name', 'aurora' | first %}
{% include theme-variant.html theme=aurora_theme %}

## Generate a variant preview

```powershell
pwsh ./vhs/Invoke-AllThemeVarients.ps1 -Theme aurora -Variant Gradient
```

Use `-Variant Base`, `Rounded`, `Double`, or `Gradient` to render one GIF source. Omit `-Variant` or pass `All` to print all four variants in the terminal. Use any value accepted by `Show-PHTheme -Name`.

## VHS source

`New-ThemeVariantTapes.ps1` derives 200 tapes from the `Show-PHTheme` ValidateSet: four variants for each of the 50 public theme names. The `vhs_build` job renders them before the Pages build, so both theme pages use current module output rather than committed generated media.
