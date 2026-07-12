# Route a CLI subcommand through New-PHRouter.
Output ../docs/assets/images/router.gif

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

Type "$routes = @{ build = { 'build dispatched' }; default = { 'usage: demo build' } }" Enter
Type "New-PHRouter -Routes $routes -ArgumentList @('build') -ModuleName demo" Enter
Sleep 5s
