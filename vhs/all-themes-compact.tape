# VHS Tape for all-themes-compact.gif
Output ../docs/assets/images/all-themes-compact.gif

Set Shell "pwsh"
Set FontSize 20
Set Width 1200
Set Height 850
Set Padding 20
Set Theme "Dracula"
Set WindowBar Colorful

Hide
Type "Import-Module ../phwriter.psm1 -Force" Enter
Type "Clear-Host" Enter
Show

Type "Show-PHTheme -All -Compact -Layout 'Minimal'" Sleep 500ms Enter
Sleep 10s
