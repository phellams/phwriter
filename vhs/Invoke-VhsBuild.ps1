# Invoke-VhsBuild.ps1 - Compiles all VHS tapes sequentially
[cmdletbinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$VhsDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ThemeTapeGenerator = [System.IO.Path]::Combine($VhsDir, 'New-ThemeVariantTapes.ps1')
& $ThemeTapeGenerator
$TapeFiles = Get-ChildItem -Path $VhsDir -Filter "*.tape" -Recurse | Sort-Object -Property FullName

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

$ThemePreviewDir = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($VhsDir, "..", "docs", "assets", "themes-previews"))
if (-not (Test-Path $ThemePreviewDir)) {
    New-Item -Path $ThemePreviewDir -ItemType Directory -Force | Out-Null
}

Write-Host "Compiling $($TapeFiles.Count) tapes sequentially..." -ForegroundColor Yellow

foreach ($TapeFile in $TapeFiles) {
    $tapeFilePath = $TapeFile.FullName
    $tapeName = $TapeFile.Name
    Write-Host "Starting compilation for: $tapeName" -ForegroundColor Cyan
    try {
        Push-Location -LiteralPath $TapeFile.DirectoryName
        try {
            # VHS resolves shell commands and output paths from the tape directory.
            & vhs $tapeFilePath
            if ($LASTEXITCODE -ne 0) {
                throw "VHS exited with code $LASTEXITCODE."
            }

            $outputLine = [System.IO.File]::ReadAllLines($tapeFilePath) | Where-Object { $_ -match '^Output\s+' } | Select-Object -First 1
            if ([string]::IsNullOrWhiteSpace($outputLine)) {
                throw "The tape does not declare an output file."
            }

            $relativeOutputPath = ($outputLine -replace '^Output\s+', '').Trim()
            $outputPath = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($TapeFile.DirectoryName, $relativeOutputPath))
            if (-not [System.IO.File]::Exists($outputPath)) {
                throw "VHS completed without creating '$outputPath'."
            }
        }
        finally {
            Pop-Location
        }

        Write-Host "Successfully compiled: $tapeName" -ForegroundColor Green
    }
    catch {
        throw "Failed to compile ${tapeName}: $_"
    }
}

Write-Host "VHS compilation task finished!" -ForegroundColor Green
