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