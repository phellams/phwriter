# VHS Tape — phwriter.gif (main module showcase)
# Run with: vhs phwriter.tape
# Showcases: theme preview, pipeline, global config, HelpParam, router dispatch

Output phwriter.gif

Set Shell "pwsh"
Set FontSize 22
Set Width 1400
Set Height 900
Set Padding 20
Set Theme "Dracula"
Set WindowBar Colorful

# ── Hidden setup ──────────────────────────────────────────────────────────────
Hide
Type "Import-Module ./phwriter.psd1 -Force" Enter
Type "Clear-Host" Enter
Show

# ── Example 1: Show-PHTheme — cosmic with gradient border and Terminal layout ─
Type "Show-PHTheme -Name cosmic -Layout Terminal -Gradient -OuterBorder -BorderGradient -OuterBorderStyle Double -Compact" Enter
Sleep 5s

# ── Clear ─────────────────────────────────────────────────────────────────────
Hide
Type "Clear-Host" Enter
Show

# ── Example 2: Export-PHWriterMetadata piped directly to New-PHWriter ─────────
Type "Export-PHWriterMetadata -Path ./Public/New-PHWriter.ps1 -FunctionName New-PHWriter | New-PHWriter -Theme aurora -OuterBorder -OutMode Standard" Enter
Sleep 6s

# ── Clear ─────────────────────────────────────────────────────────────────────
Hide
Type "Clear-Host" Enter
Show

# ── Example 3: Global config — set theme once, all calls inherit it ───────────
Type '$global:__phwriter = @{ theme_config = @{ theme = "neon-noir"; gradient = $true } }' Enter
Sleep 1s
Type "Show-PHTheme -Name neon-noir -OuterBorder -BorderGradient -Layout Box" Enter
Sleep 5s

# ── Clear ─────────────────────────────────────────────────────────────────────
Hide
Type "Clear-Host" Enter
Show

# ── Example 4: -HelpParam — single param lookup ───────────────────────────────
Type "Export-PHWriterMetadata -Path ./Public/New-PHWriter.ps1 -FunctionName New-PHWriter | New-PHWriter -Theme cyberpunk -OutMode Standard -HelpParam Theme" Sleep 200ms Enter
Sleep 5s

# ── Clear ─────────────────────────────────────────────────────────────────────
Hide
Type "Clear-Host" Enter
Show

# ── Example 5: New-PHRouter CLI dispatch ─────────────────────────────────────
Type '$routes = @{ build = { "Building project..." }; test = { "Running tests..." }; default = { New-PHWriter -Name "mycli" -Theme "phwriter" -SourceType "router" -OutMode Standard } }' Enter
Sleep 500ms
Type "New-PHRouter -Routes `$routes -ArgumentList @('build') -ModuleName mycli" Enter
Sleep 4s
Type "New-PHRouter -Routes `$routes -ArgumentList @() -ModuleName mycli" Enter
Sleep 5s
