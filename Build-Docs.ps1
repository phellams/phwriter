<#
.SYNOPSIS
Builds or serves the PHWriter Jekyll documentation site.

.DESCRIPTION
Uses an external Bundler cache and writes generated site output to docs/public.
Paths are resolved from this script, so it can be invoked from any directory on
Windows, Linux, or macOS.

.PARAMETER Build
Installs the required gems and performs one production-style Jekyll build.

.PARAMETER Serve
Installs the required gems and starts Jekyll with live reload enabled.

.EXAMPLE
pwsh ./Build-Docs.ps1 -Build

.EXAMPLE
pwsh ./Build-Docs.ps1 -Serve
#>
[CmdletBinding(DefaultParameterSetName = 'Build')]
param(
    [Parameter(Mandatory, ParameterSetName = 'Build')]
    [switch]$Build,

    [Parameter(Mandatory, ParameterSetName = 'Serve')]
    [switch]$Serve
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Invoke-PHWriterDocs {
    [CmdletBinding(DefaultParameterSetName = 'Build')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Build')]
        [switch]$Build,

        [Parameter(Mandatory, ParameterSetName = 'Serve')]
        [switch]$Serve
    )

    $repositoryRoot = $PSScriptRoot
    $docsDirectory = [System.IO.Path]::Combine($repositoryRoot, 'docs')
    $gemfilePath = [System.IO.Path]::Combine($docsDirectory, 'Gemfile')
    $destination = [System.IO.Path]::Combine($docsDirectory, 'public')
    $bundlePath = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), 'phwriter-bundle')

    if (-not [System.IO.File]::Exists($gemfilePath)) {
        throw "Jekyll Gemfile was not found at '$gemfilePath'."
    }

    if (-not (Get-Command -Name bundle -ErrorAction Ignore)) {
        throw "Bundler was not found. Install Ruby and Bundler, then run this command again."
    }

    $previousBundleIgnoreConfig = $env:BUNDLE_IGNORE_CONFIG
    $previousBundlePath = $env:BUNDLE_PATH
    $env:BUNDLE_IGNORE_CONFIG = '1'
    $env:BUNDLE_PATH = $bundlePath

    try {
        Push-Location -LiteralPath $docsDirectory
        & bundle install
        if ($LASTEXITCODE -ne 0) {
            throw "Bundler installation failed with exit code $LASTEXITCODE."
        }

        if ($Build) {
            & bundle exec jekyll build --destination $destination
        }
        else {
            & bundle exec jekyll serve --destination $destination --livereload
        }

        if ($LASTEXITCODE -ne 0) {
            throw "Jekyll exited with code $LASTEXITCODE."
        }
    }
    finally {
        Pop-Location
        if ($null -eq $previousBundleIgnoreConfig) {
            Remove-Item -Path Env:BUNDLE_IGNORE_CONFIG -ErrorAction Ignore
        }
        else {
            $env:BUNDLE_IGNORE_CONFIG = $previousBundleIgnoreConfig
        }

        if ($null -eq $previousBundlePath) {
            Remove-Item -Path Env:BUNDLE_PATH -ErrorAction Ignore
        }
        else {
            $env:BUNDLE_PATH = $previousBundlePath
        }
    }
}

Invoke-PHWriterDocs @PSBoundParameters
