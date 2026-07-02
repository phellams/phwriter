# VHS Tape for compact-example.gif
# Run with: vhs demo/compact-example.tape

Output demo/compact-example.gif

Set Shell "pwsh"
Set FontSize 26
Set Width 1200
Set Height 600
Set Padding 20
Set Theme "Dracula"
Set WindowBar Colorful

# Hide setup steps
Hide
Type "Import-Module ./phwriter.psd1 -Force" Enter
Type "Clear-Host" Enter
Show

# Type the demo command
Type "New-PHWriter -Name 'MyModule' -Theme 'cyberpunk' -Compact" Sleep 500ms Enter

# Allow the output to be displayed
Sleep 6s
