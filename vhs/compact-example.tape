# VHS Tape for compact-example.gif
Output ../docs/assets/images/compact-example.gif

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

Type "New-PHWriter -Name 'MyModule' -Theme 'cyberpunk' -Compact" Sleep 500ms Enter
Sleep 6s
