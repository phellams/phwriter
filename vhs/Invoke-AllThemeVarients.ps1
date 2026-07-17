<#
.SYNOPSIS
Renders one New-PHWriter document with its border and gradient variants.

.DESCRIPTION
Prints a base preview, rounded and double outer-border previews, and a
custom-gradient outer-border preview for a selected built-in theme. Each
variant invokes New-PHWriter with representative command metadata. The script
is designed for direct terminal use and as a VHS recording source.

.PARAMETER Theme
The built-in theme to render. Defaults to phwriter.

.PARAMETER Layout
The logo layout passed to Show-PHTheme. Defaults to Minimal.

.PARAMETER Variant
The presentation variant to render. Use All to render every variant.

.EXAMPLE
pwsh ./vhs/Invoke-AllThemeVarients.ps1 -Theme aurora
#>
[CmdletBinding()]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$Theme = 'phwriter',

    [Parameter()]
    [ValidateSet('Box', 'Classic', 'Minimal', 'Man', 'Terminal', 'Typewriter')]
    [string]$Layout = 'Minimal',

    [Parameter()]
    [ValidateSet('All', 'Base', 'Rounded', 'Double', 'Gradient')]
    [string]$Variant = 'All'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = [System.IO.Path]::GetDirectoryName($PSScriptRoot)
$manifestPath = [System.IO.Path]::Combine($repositoryRoot, 'phwriter.psd1')
Import-Module -Name $manifestPath -Force

$showThemeCommand = Get-Command -Name Show-PHTheme -ErrorAction Stop
$nameParameter = $showThemeCommand.Parameters['Name']
$validThemeNames = @($nameParameter.Attributes |
    Where-Object { $_ -is [System.Management.Automation.ValidateSetAttribute] } |
    ForEach-Object { $_.ValidValues } |
    Where-Object { $_ -notin @('all', 'custom-rgb') })

if ($Theme -notin $validThemeNames) {
    throw "Unknown theme '$Theme'. Choose one of: $($validThemeNames -join ', ')."
}

$gradientStops = [int[]]@(39, 51, 129, 201)
$commandInfo = @{
    cmdlet = 'Get-SampleData'
    synopsis = 'Get-SampleData [-Path <String>] [-Force]'
    description = 'Representative command help used to record PHWriter theme variants.'
    source = 'https://gitlab.com/phellams/phwriter'
}
$paramTable = @(
    @{ name = 'Path'; param = 'p|Path'; type = 'String'; description = 'Path to the input data.'; required = $true; inline = $false }
    @{ name = 'Force'; param = 'f|Force'; type = 'Switch'; description = 'Run without confirmation.'; required = $false; inline = $true }
)
$examples = @("Get-SampleData -Path './input.json' -Force")
$variants = @(
    [ordered]@{ Name = 'Base'; Label = 'Base'; Parameters = @{} }
    [ordered]@{ Name = 'Rounded'; Label = 'Rounded outer border'; Parameters = @{ OuterBorder = $true } }
    [ordered]@{ Name = 'Double'; Label = 'Double outer border'; Parameters = @{ OuterBorder = $true; OuterBorderStyle = 'Double' } }
    [ordered]@{
        Name = 'Gradient'
        Label = 'Custom header and border gradient'
        Parameters = @{
            Gradient = $true
            CustomGradient = $gradientStops
            OuterBorder = $true
            BorderGradient = $true
            BorderCustomGradient = $gradientStops
        }
    }
)

if ($Variant -ne 'All') {
    $variants = @($variants | Where-Object { $_.Name -eq $Variant })
}

foreach ($variantDefinition in $variants) {
    [Console]::WriteLine()
    [Console]::WriteLine("=== $Theme : $($variantDefinition.Label) ===")
    $writerParameters = @{
        Name = 'SAMPLE'
        CommandInfo = $commandInfo
        ParamTable = $paramTable
        Examples = $examples
        Theme = $Theme
        Layout = $Layout
        Compact = $true
    }
    foreach ($parameter in $variantDefinition.Parameters.GetEnumerator()) {
        $writerParameters[$parameter.Key] = $parameter.Value
    }
    New-PHWriter @writerParameters
}
