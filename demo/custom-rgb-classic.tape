# VHS Tape for custom-rgb-classic.gif
# Run with: vhs demo/custom-rgb-classic.tape

Output demo/custom-rgb-classic.gif

Set Shell "pwsh"
Set FontSize 22
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
Type "Show-PHTheme -Name 'custom-rgb' -Layout 'Classic'" Sleep 500ms Enter

# Allow the output to be displayed
Sleep 6s
