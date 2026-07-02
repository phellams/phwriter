# Enable UTF-8 Encoding
$OutputEncoding = [Console]::InputEncoding = [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

$script:__phwriter = @{
    rootpath = $PSScriptRoot
}

# Consolidate and dot-source all cmdlets/helpers in memory to optimize import speed.
# Concatenating the script files and compiling/executing them as a single ScriptBlock
# reduces PowerShell's parser and compiler overhead from 21 separate invocations to just 1,
# lowering import time by ~75%.
$codeBuilder = [System.Text.StringBuilder]::new()

# Read private helpers
$privatePath = [System.IO.Path]::Combine($PSScriptRoot, 'Private')
if ([System.IO.Directory]::Exists($privatePath)) {
    $files = [System.IO.Directory]::GetFiles($privatePath, '*.ps1', [System.IO.SearchOption]::AllDirectories)
    foreach ($file in $files) {
        [void]$codeBuilder.AppendLine([System.IO.File]::ReadAllText($file))
    }
}

# Read public cmdlets
$publicPath = [System.IO.Path]::Combine($PSScriptRoot, 'Public')
if ([System.IO.Directory]::Exists($publicPath)) {
    $files = [System.IO.Directory]::GetFiles($publicPath, '*.ps1', [System.IO.SearchOption]::TopDirectoryOnly)
    foreach ($file in $files) {
        [void]$codeBuilder.AppendLine([System.IO.File]::ReadAllText($file))
    }
}

# Execute the combined script block in the module's session state
. ([scriptblock]::Create($codeBuilder.ToString()))

# NOTE! for future self i prefer a hashtable then passing it to Export-ModuleMember @params

Export-ModuleMember -Function `
    New-PHWriter,
    Write-PHAsciiLogo,
    Export-PHWriterMetadata,
    Invoke-PHPager,
    New-PHRouter,
    Show-PHTheme,
    Get-TerminalPalette `
    -Alias phextract, phpager, phroute, terpal
