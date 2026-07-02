# showcase-themes.ps1 - Live-colored terminal theme previewer
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Ensure module is loaded
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ParentModule = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($ScriptDir, "..", "phwriter.psm1"))
if (Test-Path $ParentModule) {
    Import-Module $ParentModule -Force
}

$ShowcaseThemes = @(
    'phwriter',
    'cyberpunk',
    'aurora',
    'dracula',
    'glitch',
    'vaporwave',
    'crystal',
    'blood-moon'
)

Clear-Host
Write-Host "==========================================================" -ForegroundColor Yellow
Write-Host "         PHWriter Live Color Themes Showcase" -ForegroundColor Yellow -NoNewline
Write-Host " v2.0.0" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Yellow
Write-Host "This script will preview 8 highly-styled terminal themes." -ForegroundColor Gray
Write-Host "Press any key to start..." -ForegroundColor Gray
$null = [Console]::ReadKey($true)

foreach ($theme in $ShowcaseThemes) {
    Clear-Host
    Write-Host "Showing Theme: '$theme' (Press Ctrl+C to exit)...`n" -ForegroundColor Yellow
    
    # Renders the theme in Standard mode (direct stdout)
    Show-PHTheme -Name $theme -Layout 'Terminal' -SourceType 'tool'
    
    Write-Host "`n[Pause] Press any key to view next theme..." -ForegroundColor Gray
    $null = [Console]::ReadKey($true)
}

Clear-Host
Write-Host "Showcase finished! Explore all 41 themes using 'Show-PHTheme -All'." -ForegroundColor Green
