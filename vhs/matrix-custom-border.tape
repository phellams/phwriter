# VHS Tape for matrix-custom-border.gif
Output ../docs/assets/images/matrix-custom-border.gif

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

Type "Show-PHTheme -Name 'matrix' -OuterBorder -BorderCustomGradient @(22, 28, 40, 46)" Sleep 500ms Enter
Sleep 6s
