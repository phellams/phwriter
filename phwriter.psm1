# Enable UTF-8 Encoding
$OutputEncoding = [Console]::InputEncoding = [Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

$script:__phwriter = @{
    rootpath = $PSScriptRoot
}

# Dot-source all private helpers recursively using high-performance .NET calls
$privatePath = [System.IO.Path]::Combine($PSScriptRoot, 'Private')
if ([System.IO.Directory]::Exists($privatePath)) {
    $files = [System.IO.Directory]::GetFiles($privatePath, '*.ps1', [System.IO.SearchOption]::AllDirectories)
    foreach ($file in $files) {
        . $file
    }
}

# Dot-source all public cmdlets using high-performance .NET calls
$publicPath = [System.IO.Path]::Combine($PSScriptRoot, 'Public')
if ([System.IO.Directory]::Exists($publicPath)) {
    $files = [System.IO.Directory]::GetFiles($publicPath, '*.ps1', [System.IO.SearchOption]::TopDirectoryOnly)
    foreach ($file in $files) {
        . $file
    }
}

# Strictly control public exports
Export-ModuleMember -Function New-PHWriter, Write-PHAsciiLogo
