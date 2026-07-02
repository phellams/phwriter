# Build-Demos.ps1
# Automates rendering of all VHS tape files in the repository.
# Run from repository root or demo directory: pwsh demo/Build-Demos.ps1

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = (Resolve-Path (Join-Path $scriptDir "..")).Path

# Find vhs compiler
if (-not (Get-Command vhs -ErrorAction SilentlyContinue)) {
    Write-Error "vhs utility not found in PATH. Please install it from https://github.com/charmbracelet/vhs"
    exit 1
}

# Find all .tape files
$tapes = Get-ChildItem -Path $repoRoot -Filter "*.tape" -Recurse | Where-Object { $_.FullName -notlike "*node_modules*" }

Write-Host "==========================================" -ForegroundColor Green
Write-Host "PHWriter VHS Demo Builder" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host "Found $($tapes.Count) tape file(s) to process.`n" -ForegroundColor Cyan

foreach ($tape in $tapes) {
    $relativePath = [System.IO.Path]::GetRelativePath($repoRoot, $tape.FullName)
    Write-Host "[*] Rendering: $relativePath..." -ForegroundColor Yellow
    
    # Run vhs tool
    vhs $tape.FullName
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[+] Successfully rendered $relativePath" -ForegroundColor Green
    } else {
        Write-Warning "[-] Failed to render $relativePath (exit code $LASTEXITCODE)"
    }
    Write-Host
}

Write-Host "All recordings processed!" -ForegroundColor Green
