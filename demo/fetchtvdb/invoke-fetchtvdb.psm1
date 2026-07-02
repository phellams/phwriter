# invoke-fetchtvdb.psm1 - Root Module Loader for FetchTVDB Demo Module
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$ModuleRoot = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Path)

# Ensure parent PHWriter module is imported in session
if (-not (Get-Command New-PHWriter -ErrorAction SilentlyContinue)) {
    $parentPsm = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($ModuleRoot, "..", "..", "phwriter.psm1"))
    if ([System.IO.File]::Exists($parentPsm)) {
        Import-Module $parentPsm -ErrorAction SilentlyContinue
    }
}

# High-Performance .NET File Enumeration
$TargetPattern = "*.ps1"
$SearchOption = [System.IO.SearchOption]::AllDirectories
$ScriptFiles = [System.IO.Directory]::GetFiles($ModuleRoot, $TargetPattern, $SearchOption)

$PublicFunctions = [System.Collections.Generic.List[string]]::new()

foreach ($File in $ScriptFiles) {
    . $File
    $FileName = [System.IO.Path]::GetFileNameWithoutExtension($File)
    if ($FileName -match '^Invoke-FetchTvdb$') {
        $PublicFunctions.Add($FileName)
    }
}

# Strictly export only the router function member
Export-ModuleMember -Function $PublicFunctions.ToArray() -Variable @()
