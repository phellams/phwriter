<#
.SYNOPSIS
Renders one PHWriter theme with its border and gradient variants.

.DESCRIPTION
Prints a base preview, rounded and double outer-border previews, and a
custom-gradient outer-border preview for a selected built-in theme. The script
is designed for direct terminal use and as a VHS recording source.

.PARAMETER Theme
The built-in theme to render. Defaults to phwriter.

.PARAMETER Layout
The logo layout passed to Show-PHTheme. Defaults to Minimal.

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
    [string]$Layout = 'Minimal'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repositoryRoot = [System.IO.Path]::GetDirectoryName($PSScriptRoot)
$manifestPath = [System.IO.Path]::Combine($repositoryRoot, 'phwriter.psd1')
Import-Module -Name $manifestPath -Force

$showThemeCommand = Get-Command -Name Show-PHTheme -ErrorAction Stop
$nameParameter = $showThemeCommand.Parameters['Name']
$validThemeNames = @(
    $nameParameter.Attributes |
        Where-Object { $_ -is [System.Management.Automation.ValidateSetAttribute] } |
        ForEach-Object { $_.ValidValues } |
        Where-Object { $_ -notin @('all', 'custom-rgb') }
)

if ($Theme -notin $validThemeNames) {
    throw "Unknown theme '$Theme'. Choose one of: $($validThemeNames -join ', ')."
}

$gradientStops = [int[]]@(39, 51, 129, 201)
$variants = @(
    [ordered]@{ Label = 'Base'; Parameters = @{} }
    [ordered]@{ Label = 'Rounded outer border'; Parameters = @{ OuterBorder = $true } }
    [ordered]@{ Label = 'Double outer border'; Parameters = @{ OuterBorder = $true; OuterBorderStyle = 'Double' } }
    [ordered]@{
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

foreach ($variant in $variants) {
    [Console]::WriteLine()
    [Console]::WriteLine("=== $Theme : $($variant.Label) ===")
    $variantParameters = $variant.Parameters
    Show-PHTheme -Name $Theme -Layout $Layout -Minimal @variantParameters
}
