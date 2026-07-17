# Extract comment-based help metadata through the PowerShell AST.
Output ../docs/assets/images/metadata-extraction.gif

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

Type "Export-PHWriterMetadata -Path ../Public/New-PHWriter.ps1 -FunctionName New-PHWriter | Format-List name, version, sourcetype" Enter
Sleep 6s
