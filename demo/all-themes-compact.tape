# VHS Tape for all-themes-compact.gif
# Run with: vhs demo/all-themes-compact.tape

Output demo/all-themes-compact.gif

Set Shell "pwsh"
Set FontSize 20
Set Width 1200
Set Height 600
Set Padding 20
Set Theme "Dracula"
Set WindowBar Colorful
Set PlaybackSpeed 1.5

# Hide setup steps
Hide
Type "Import-Module ./phwriter.psd1 -Force" Enter
Type "Clear-Host" Enter
Show

# Type the demo command to preview all themes
Type "Show-PHTheme -All -Compact -Layout 'Minimal'" Sleep 500ms Enter

# Allow enough time for all themes to scroll through
Sleep 15s
