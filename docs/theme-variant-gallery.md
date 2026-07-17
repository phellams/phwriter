---
layout: default
title: Theme Variant Gallery
nav_order: 8
description: "Terminal previews of PHWriter border and gradient variants."
---

# Theme Variant Gallery

Every selectable PHWriter theme has Base, Rounded, Double, and Gradient recordings generated through `New-PHWriter`.

{% assign theme_groups = site.data.themes.base_themes | concat: site.data.themes.gradient_themes | concat: site.data.themes.extended_themes | concat: site.data.themes.hard_bordered_themes %}
<div class="ph-theme-variants">
{% for theme in theme_groups %}
{% include theme-variant.html theme=theme %}
{% endfor %}
</div>

## Generate a variant preview

```powershell
$metadata = @{
    Name = 'SAMPLE'
    CommandInfo = @{ cmdlet = 'Get-SampleData'; synopsis = 'Get-SampleData [-Path <String>]'; description = 'Sample output.'; source = 'https://gitlab.com/phellams/phwriter' }
}
New-PHWriter @metadata -Theme 'aurora' -Layout Minimal -Compact -Gradient -CustomGradient 39,51,129,201 -OuterBorder -BorderGradient -BorderCustomGradient 39,51,129,201
```

The gallery’s command cards show the specific flags for Base, Rounded, Double, and Gradient output. Use any value accepted by `Show-PHTheme -Name`; `New-PHWriter` accepts the same 50 built-in theme names.

## VHS source

`New-ThemeVariantTapes.ps1` derives 200 tapes from the `Show-PHTheme` ValidateSet: four variants for each of the 50 public theme names. The `vhs_build` job renders them before the Pages build, so both theme pages use current module output rather than committed generated media.
