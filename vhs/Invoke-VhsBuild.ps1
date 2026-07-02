# Invoke-VhsBuild.ps1 - Compiles all VHS tapes sequentially
[cmdletbinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$VhsDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$TapeFiles = Get-ChildItem -Path $VhsDir -Filter "*.tape"

# Check if vhs tool is installed
if (-not (Get-Command vhs -ErrorAction SilentlyContinue)) {
    Write-Warning "The Charm 'vhs' CLI tool is not installed or not in the PATH. Cannot compile tapes to GIFs."
    Write-Warning "Please install it from https://github.com/charmbracelet/vhs before running."
    return
}

# Ensure output directory exists in docs assets
$DocsImgDir = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($VhsDir, "..", "docs", "assets", "images"))
if (-not (Test-Path $DocsImgDir)) {
    New-Item -Path $DocsImgDir -ItemType Directory -Force | Out-Null
}

Write-Host "Compiling $($TapeFiles.Count) tapes sequentially..." -ForegroundColor Yellow

foreach ($TapeFile in $TapeFiles) {
    $tapeFilePath = $TapeFile.FullName
    $tapeName = $TapeFile.Name
    Write-Host "Starting compilation for: $tapeName" -ForegroundColor Cyan
    try {
        # Run vhs compiler
        vhs $tapeFilePath
        Write-Host "Successfully compiled: $tapeName" -ForegroundColor Green
    }
    catch {
        Write-Error "Failed to compile ${tapeName}: $_"
    }
}

Write-Host "VHS compilation task finished!" -ForegroundColor Green
