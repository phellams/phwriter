# Demo script showcasing the themes and palette capabilities of PHWriter

# 1. Import the module locally
$modulePath = Join-Path $PSScriptRoot ".." "phwriter.psd1"
if (Test-Path $modulePath) {
    Import-Module -Name $modulePath -Force
} else {
    Import-Module -Name (Join-Path $PSScriptRoot "phwriter.psd1") -Force
}

Write-Host "==========================================" -ForegroundColor Green
Write-Host "PHWriter Theme and Palette Demo" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host

# 2. Preview a singular theme in full customization mode
Write-Host "[1/4] Previewing the 'cyberpunk' theme in full mode..." -ForegroundColor Cyan
Show-PHTheme -Name 'cyberpunk' -Layout 'Terminal'
Write-Host "Press enter to continue..."
$null = Read-Host

# 3. Preview a custom RGB true-color theme
Write-Host "[2/4] Previewing a custom RGB/TrueColor theme ('custom-rgb')..." -ForegroundColor Cyan
Show-PHTheme -Name 'custom-rgb' -Layout 'Classic'
Write-Host "Press enter to continue..."
$null = Read-Host

# 4. Preview all themes in minimal layout mode
Write-Host "[3/4] Previewing all 50 themes in minimal layout mode..." -ForegroundColor Cyan
Show-PHTheme -All -Minimal -Layout 'Box'
Write-Host "Press enter to continue..."
$null = Read-Host

# 5. Show how to use Get-TerminalPalette (terpal) helper directly for custom coding
Write-Host "[4/4] Showing Get-TerminalPalette (terpal) dynamic gradient coloring..." -ForegroundColor Cyan
Write-Host

# Create a gradient palette from Red to Blue
$gradientPal = Get-TerminalPalette `
    -ColorMode 'Gradient' `
    -GradientStart @(255, 0, 0) `
    -GradientEnd @(0, 0, 255)

$testString = "This is a dynamically colorized string using a custom RGB gradient!"
$chars = $testString.ToCharArray()
for ($i = 0; $i -lt $chars.Count; $i++) {
    $colorCode = $gradientPal.GetFillColor.Invoke($i, $chars.Count)
    Write-Host -NoNewline ($gradientPal.Apply.Invoke($chars[$i], $colorCode))
}
Write-Host
Write-Host
Write-Host "Demo finished!" -ForegroundColor Green
