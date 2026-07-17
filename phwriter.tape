# VHS Tape for phwriter.gif (Main module demo)
# Run with: vhs phwriter.tape

Output phwriter.gif

Set Shell "pwsh"
Set FontSize 24
Set Width 1380
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
Type "show-phTheme -Name cosmic -OuterBorder -BorderGradient -Layout Terminal -GradientMode Vertical -OuterBorderStyle Square -Gradient -SourceType module -Compact"
Sleep 4s

# Clear screen for second example
Hide
Type "Clear-Host" Enter
Show

# Render module help in Compact mode
Type "New-PHWriter -Name 'MyModule' -Theme 'cyberpunk' -Layout 'man' -OuterBorder" Sleep 500ms Enter
Sleep 6s


# Render module help in Compact mode
Type "New-PHWriter -Name 'MyModule' -Theme 'cyberpunk' -Layout 'man' -OuterBorder -OuterBorderStyle box" Sleep 500ms Enter
Sleep 6s