BeforeAll { 
    # Import the module
    Import-Module -Name ./phwriter.psm1 -Force

    # Dot-source private helper files directly in the test scope for unit testing
    . ./Private/New-AsciiColor.ps1
    . ./Private/New-AsciiGradient.ps1
    . ./Private/Get-PHTheme.ps1

    $params = @{
        Name        = 'TestModule'
        Version     = '2.0.1'
        CommandInfo = @{
            cmdlet      = "Get-Data"
            synopsis    = "Get-Data [-Path <string>]"
            description = "Get awesome data."
            source      = "https://example.com/docs"
        }
        ParamTable  = @(
            @{
                Name        = "Path"
                Param       = "p|Path"
                Type        = "string"
                required    = $true
                Description = "Path to the data."
                Inline      = $false
            }
        )
        Examples = @(
            "Get-Data -Path 'C:\data'"
        )
    }

    $routerParams = @{
        Name        = 'TestRouter'
        Version     = '1.1.0'
        CommandInfo = @{
            cmdlet      = "mytool"
            synopsis    = "mytool <command> [options]"
            description = "A command router function."
            source      = "https://example.com/tool"
        }
        Subcommands = @(
            @{
                Name        = "init"
                Syntax      = "init [-Force]"
                Description = "Initialize the workspace."
            },
            @{
                Name        = "run"
                Syntax      = "run [-Config <path>]"
                Description = "Run processing."
            }
        )
        ParamTable  = @(
            @{
                Name        = "Verbose"
                Param       = "v|Verbose"
                type        = "switch"
                required    = $false
                Description = "Show verbose logs."
                inline      = $true
            }
        )
        Examples = @(
            "mytool init -Force",
            "mytool run -Config config.json"
        )
    }
}

Describe "Get-PHTheme" {
    It "Should return the default theme by default" {
        $theme = Get-PHTheme
        $theme | Should -Not -BeNullOrEmpty
        $theme.AccentColor | Should -Be 'darkgreen'
    }

    It "Should return the default theme on invalid name" {
        $theme = Get-PHTheme -Name 'invalid-theme-name'
        $theme | Should -Not -BeNullOrEmpty
        $theme.AccentColor | Should -Be 'darkgreen'
    }

    It "Should load default theme" { (Get-PHTheme 'default') | Should -Not -BeNullOrEmpty }
    It "Should load matrix theme" { (Get-PHTheme 'matrix') | Should -Not -BeNullOrEmpty }
    It "Should load cyberpunk theme" { (Get-PHTheme 'cyberpunk') | Should -Not -BeNullOrEmpty }
    It "Should load dracula theme" { (Get-PHTheme 'dracula') | Should -Not -BeNullOrEmpty }
    It "Should load nord theme" { (Get-PHTheme 'nord') | Should -Not -BeNullOrEmpty }
    It "Should load monokai theme" { (Get-PHTheme 'monokai') | Should -Not -BeNullOrEmpty }
    It "Should load solarized theme" { (Get-PHTheme 'solarized') | Should -Not -BeNullOrEmpty }
    It "Should load sunset theme" { (Get-PHTheme 'sunset') | Should -Not -BeNullOrEmpty }
    It "Should load forest theme" { (Get-PHTheme 'forest') | Should -Not -BeNullOrEmpty }
    It "Should load classic theme" { (Get-PHTheme 'classic') | Should -Not -BeNullOrEmpty }
}

Describe "Write-PHAsciiLogo" {
    It "Should render logo with Box layout" {
        Write-PHAsciiLogo -Name 'TestMod' -Version '1.2.3' -Layout 'Box'
    }
    It "Should render logo with Classic layout" {
        Write-PHAsciiLogo -Name 'TestMod' -Version '1.2.3' -Layout 'Classic'
    }
    It "Should render logo with Minimal layout" {
        Write-PHAsciiLogo -Name 'TestMod' -Version '1.2.3' -Layout 'Minimal'
    }
    It "Should render logo with Man layout" {
        Write-PHAsciiLogo -Name 'TestMod' -Version '1.2.3' -Layout 'Man'
    }
    It "Should render logo with Terminal layout" {
        Write-PHAsciiLogo -Name 'TestMod' -Version '1.2.3' -Layout 'Terminal'
    }
    It "Should render logo with Typewriter layout" {
        Write-PHAsciiLogo -Name 'TestMod' -Version '1.2.3' -Layout 'Typewriter'
    }
}

Describe "New-PHWriter" {
    It "Should render standard cmdlet help without throwing" {
        New-PHWriter @params
    }

    It "Should render help with subcommands (router function) without throwing" {
        New-PHWriter @routerParams
    }

    It "Should respect LineSpacing, SourceType, and Padding parameters" {
        $customParams = $params.Clone()
        $customParams['LineSpacing'] = 0
        $customParams['SourceType'] = 'script'
        $customParams['Padding'] = 1
        New-PHWriter @customParams
    }
}

Describe "New-AsciiColor" {
    It "Should colorize text using ANSI escapes" {
        $redText = New-AsciiColor -String 'Hello' -Color 'red'
        $redText | Should -BeLike '*Hello*'
        [int]$redText.ToCharArray()[0] | Should -Be 27
    }

    It "Should support formatting flags" {
        $boldText = New-AsciiColor -String 'Hello' -Format 'bold','italic'
        $boldText | Should -BeLike '*Hello*'
    }
}

Describe "New-AsciiGradient" {
    It "Should generate foreground gradient successfully" {
        $grad = New-AsciiGradient -Type 'fg' -Steps @(196, 226) -String 'Rainbow'
        $grad | Should -BeLike '*R*'
    }
}

Describe "Export-PHWriterMetadata" {
    It "Should extract metadata from Write-PHAsciiLogo.ps1" {
        $meta = Export-PHWriterMetadata -Path "$PSScriptRoot/../Public/Write-PHAsciiLogo.ps1" -FunctionName "Write-PHAsciiLogo"
        $meta | Should -Not -BeNullOrEmpty
        $meta.name | Should -Be 'phwriter'
        $meta.version | Should -BeLike '*.*.*'
        $meta.sourcetype | Should -Be 'module'
        $meta.commandinfo.cmdlet | Should -Be 'Write-PHAsciiLogo'
    }

    It "Should respect FunctionName filter" {
        $meta = Export-PHWriterMetadata -Path "$PSScriptRoot/../Public/Write-PHAsciiLogo.ps1" -FunctionName "Write-PHAsciiLogo"
        $meta | Should -Not -BeNullOrEmpty
        $meta.commandinfo.cmdlet | Should -Be 'Write-PHAsciiLogo'
    }

    It "Should output JSON file when requested" {
        $tempJson = [System.IO.Path]::GetTempFileName() + ".json"
        try {
            $meta = Export-PHWriterMetadata -Path "$PSScriptRoot/../Public/Write-PHAsciiLogo.ps1" -FunctionName "Write-PHAsciiLogo" -OutputJson $tempJson
            $meta | Should -Not -BeNullOrEmpty
            [System.IO.File]::Exists($tempJson) | Should -Be $true
            $loaded = Get-Content -Path $tempJson -Raw | ConvertFrom-Json
            $loaded.name | Should -Be 'phwriter'
        } finally {
            if ([System.IO.File]::Exists($tempJson)) {
                [System.IO.File]::Delete($tempJson)
            }
        }
    }
}

Describe "New-PHRouter" {
    It "Should dispatch exact match subcommand scriptblock" {
        $state = @{ called = $false }
        $routes = @{
            'test' = { $state.called = $true }
        }
        New-PHRouter -Routes $routes -ArgumentList @('test')
        $state.called | Should -Be $true
    }

    It "Should dispatch default route when no subcommand matches" {
        $state = @{ called = $false }
        $routes = @{
            'test' = { }
            'default' = { $state.called = $true }
        }
        New-PHRouter -Routes $routes -ArgumentList @()
        $state.called | Should -Be $true
    }

    It "Should register native completer without throwing" {
        New-PHRouter -Routes @{ 'a' = {} } -ArgumentList @() -ModuleName 'TestComplete' -RegisterCompleter
    }

    It "Should perform fuzzy suggestion on unknown subcommand" {
        $routes = @{
            'build' = { }
            'test'  = { }
        }
        New-PHRouter -Routes $routes -ArgumentList @('buid') -ModuleName 'FuzzyTest'
    }

    It "Should dispatch exact match function name string route" {
        function global:Invoke-TestRouterTarget { $script:routerState.called = $true }
        $script:routerState = @{ called = $false }
        try {
            $routes = @{
                'test' = 'Invoke-TestRouterTarget'
            }
            New-PHRouter -Routes $routes -ArgumentList @('test')
            $script:routerState.called | Should -Be $true
        } finally {
            $script:routerState = $null
            Remove-Item -Path "function:\Invoke-TestRouterTarget" -ErrorAction SilentlyContinue
        }
    }
}

Describe "Invoke-PHPager" {
    It "Should render plain text content without throwing in test mode" {
        $env:PHWRITER_TEST_MODE = 'true'
        try {
            "Line 1", "Line 2" | Invoke-PHPager -Title 'Test Pager' -NoColor
        } finally {
            $env:PHWRITER_TEST_MODE = $null
        }
    }

    It "Should render ANSI colorized content in test mode" {
        $env:PHWRITER_TEST_MODE = 'true'
        try {
            "Line 1 with `e[31mRed`e[0m text" | Invoke-PHPager -Title 'Test Color Pager'
        } finally {
            $env:PHWRITER_TEST_MODE = $null
        }
    }
}