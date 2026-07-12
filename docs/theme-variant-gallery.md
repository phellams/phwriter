---
layout: default
title: Theme Variant Gallery
nav_order: 8
description: "Terminal previews of PHWriter border and gradient variants."
---

# Theme Variant Gallery

`Invoke-AllThemeVarients.ps1` renders each supported presentation variant for a selected built-in theme.

![Aurora theme variants](./assets/images/theme-variants.gif)

## Generate a variant preview

```powershell
pwsh ./vhs/Invoke-AllThemeVarients.ps1 -Theme aurora
```

The script renders the base theme, rounded outer border, double outer border, and custom header/border gradient. Use any value accepted by `Show-PHTheme -Name`.

## VHS source

The `vhs/theme-variants.tape` recording invokes the script with the `aurora` theme. The `vhs_build` job renders it before the Pages build, so the gallery uses current module output rather than committed generated media.
