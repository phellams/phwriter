# Render the standalone ASCII logo with a token-aware gradient.
Output ../docs/assets/images/ascii-logo.gif

Set Shell "pwsh"
Set FontSize 18
Set Width 1200
Set Height 700
Set Padding 20
Set Theme "Dracula"
Set WindowBar Colorful

Hide
Type "Import-Module ../phwriter.psd1 -Force" Enter
Type "Clear-Host" Enter
Show

Type "Write-PHAsciiLogo -Name PHWriter -Version 0.19.0 -Theme aurora -Gradient -GradientMode PerToken" Enter
Sleep 5s
