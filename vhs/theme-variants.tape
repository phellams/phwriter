# Compare a solid, gradient, and hard-bordered theme.
Output ../docs/assets/images/theme-variants.gif

Set Shell "pwsh"
Set FontSize 16
Set Width 1200
Set Height 850
Set Padding 20
Set Theme "Dracula"
Set WindowBar Colorful

Hide
Type "Import-Module ../phwriter.psd1 -Force" Enter
Type "Clear-Host" Enter
Show

Type "Show-PHTheme -Name phwriter -Minimal" Enter
Type "Show-PHTheme -Name aurora -Minimal -Gradient -OuterBorder -BorderGradient" Enter
Type "Show-PHTheme -Name cyber-grid -Minimal -OuterBorder -OuterBorderStyle Double" Enter
Sleep 8s
