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

Type "pwsh -NoProfile -File ./Invoke-AllThemeVarients.ps1 -Theme aurora" Enter
Sleep 8s
