# VHS Tape for phwriter.gif (Main module demo)
# Run with: vhs phwriter.tape

Output phwriter.gif

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

# Render module help with default Box layout
Type "New-PHWriter -Name 'MyModule' -Theme 'cyberpunk' -Layout 'box'" Sleep 500ms Enter
Sleep 4s

# Clear screen for second example
Hide
Type "Clear-Host" Enter
Show

# Render module help in Compact mode
Type "New-PHWriter -Name 'MyModule' -Theme 'cyberpunk' -Layout 'Terminal' -Compact" Sleep 500ms Enter
Sleep 6s


# Render module help in Compact mode
Type "New-PHWriter -Name 'MyModule' -Theme '' -Layout 'Terminal' -Compact" Sleep 500ms Enter
Sleep 6s