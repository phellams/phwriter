Describe "phwriter Unit Tests" {
BeforeAll { 
    $script:originalNoColor = $env:NO_COLOR
    Remove-Item -Path Env:NO_COLOR -ErrorAction SilentlyContinue
    $env:PHWRITER_TEST_MODE = 'true'
    # Import the module
    Import-Module -Name ./phwriter.psm1 -Force
}
AfterAll {
    if ($null -eq $script:originalNoColor) {
        Remove-Item -Path Env:NO_COLOR -ErrorAction SilentlyContinue
    } else {
        $env:NO_COLOR = $script:originalNoColor
    }
}
BeforeEach {
    $env:PHWRITER_TEST_MODE = 'true'

    # Dot-source private helper files directly in the test scope for unit testing
    . ./Private/New-AsciiColor.ps1
    . ./Private/New-AsciiGradient.ps1
    . ./Private/Get-PHTheme.ps1
    . ./Private/clap.ps1

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

Context "Get-PHTheme" {
    It "Should return the default theme by default" {
        $theme = Get-PHTheme
        $theme | Should -Not -BeNullOrEmpty
        $theme.AccentColor | Should -Be '214'
    }

    It "Should return the default theme on invalid name" {
        $theme = Get-PHTheme -Name 'invalid-theme-name'
        $theme | Should -Not -BeNullOrEmpty
        $theme.AccentColor | Should -Be '214'
    }

    It "Should load all predefined themes without throwing" {
        $names = @(
            'default', 'matrix', 'cyberpunk', 'dracula', 'nord', 'monokai', 'solarized', 
            'sunset', 'forest', 'classic', 'aurora', 'neon-noir', 'lava', 'ocean', 'toxic', 
            'midnight', 'gold', 'rose', 'steel', 'phwriter', 'phman', 'glitch', 'cosmic', 
            'forest-mist', 'blood-moon', 'retro-arcade', 'abyss', 'zen', 'blaze', 'rust', 
            'matrix-neon', 'quantum', 'radioactive', 'vaporwave', 'nebula', 'crystal', 
            'copper', 'royal', 'desert-heat', 'sheriff', 'frost',
            'drift-blue-orange', 'steel-plate', 'cyber-grid', 'retro-blocks', 'gothic-crypt',
            'acid-shards', 'aurora-borealis', 'solar-flare', 'subspace', 'neon-horizon'
        )
        foreach ($name in $names) {
            $theme = Get-PHTheme -Name $name
            $theme | Should -Not -BeNullOrEmpty
            $theme.ContainsKey('SectionChar') | Should -Be $true
        }
    }
}

Context "Show-PHTheme" {
    It "Should render a single theme in minimal mode" {
        Show-PHTheme -Name 'default' -Minimal
    }

    It "Should render a single theme in full mode" {
        Show-PHTheme -Name 'cyberpunk'
    }

    It "Should render custom-rgb theme without throwing" {
        Show-PHTheme -Name 'custom-rgb' -Minimal
    }

    It "Should render a hard-bordered theme without throwing" {
        Show-PHTheme -Name 'cyber-grid' -Minimal
    }
}

Context "Get-TerminalPalette" {
    It "Should return a palette object with functioning Apply and GetStaticColor" {
        $pal = Get-TerminalPalette -ColorPalette @{ 'Fill' = 'red'; 'Accent' = 'green' }
        $pal | Should -Not -BeNullOrEmpty
        
        $static = $pal.GetStaticColor.Invoke('Accent')
        $static | Should -BeLike '*green*'

        $applied = $pal.Apply.Invoke('text', '31') # Red foreground code
        $applied | Should -BeLike '*text*'
    }

    It "Should support Gradient mode GetFillColor" {
        $pal = Get-TerminalPalette -ColorMode 'Gradient' -GradientStart @(255, 0, 0) -GradientEnd @(0, 0, 255)
        $code = $pal.GetFillColor.Invoke(0, 10)
        $code | Should -BeLike '38;2;255;0;0'
    }

    It "Should support Conditional threshold mode" {
        $thresholds = @{
            50  = 'yellow'
            100 = 'red'
        }
        $pal = Get-TerminalPalette -ColorMode 'Conditional' -ColorThresholds $thresholds -CurrentValue 30
        $code = $pal.GetFillColor.Invoke(0, 0)
        $code | Should -BeLike '*yellow*'
    }
}

Context "Write-PHAsciiLogo" {
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

Context "New-PHWriter" {
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

    It "Should render a hard-bordered theme without throwing" {
        $customParams = $params.Clone()
        $customParams['Theme'] = 'cyber-grid'
        $customParams['OuterBorder'] = $true
        $customParams['OuterBorderStyle'] = 'Double'
        New-PHWriter @customParams
    }
}

Context "New-AsciiColor" {
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

Context "New-AsciiGradient" {
    It "Should generate foreground gradient successfully" {
        $grad = New-AsciiGradient -Type 'fg' -Steps @(196, 226) -String 'Rainbow'
        $grad | Should -BeLike '*R*'
    }
}

Context "Export-PHWriterMetadata" {
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

    It "Should generate smart aliases without conflicts" {
        $meta = Export-PHWriterMetadata -Path "$PSScriptRoot/../Public/Write-PHAsciiLogo.ps1" -FunctionName "Write-PHAsciiLogo"
        $paramTable = $meta.paramtable

        $nameParam = $paramTable | Where-Object { $_.name -eq 'Name' }
        $nameParam.param | Should -Be 'n|Name'

        $versionParam = $paramTable | Where-Object { $_.name -eq 'Version' }
        $versionParam.param | Should -Be 'v|Version'

        $layoutParam = $paramTable | Where-Object { $_.name -eq 'Layout' }
        $layoutParam.param | Should -Be 'l|Layout'

        $cgParam = $paramTable | Where-Object { $_.name -eq 'CustomGradient' }
        $cgParam.param | Should -Be 'cu|CustomGradnet|CustomGradient'

        $gmParam = $paramTable | Where-Object { $_.name -eq 'GradientMode' }
        $gmParam.param | Should -Be 'gr|GradientMode'
    }
}

Context "New-PHRouter" {
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

    It "Should dispatch default route to built-in cmdlets when routes parameter is empty" {
        $module = Get-Module phwriter
        $origSB = $module.Invoke({ Get-Command Show-PHTheme -ErrorAction SilentlyContinue | Select-Object -ExpandProperty ScriptBlock })
        
        $global:themeCalled = $false
        $module.Invoke({
            Set-Item function:\Show-PHTheme -Value { $global:themeCalled = $true }
        })
        try {
            New-PHRouter -ArgumentList @('show-phtheme')
            $global:themeCalled | Should -Be $true
        } finally {
            $global:themeCalled = $null
            if ($null -ne $origSB) {
                $module.Invoke({
                    param($sb)
                    Set-Item function:\Show-PHTheme -Value $sb
                }, $origSB)
            }
        }
    }
}

Context "Invoke-PHPager" {
    It "Should render plain text content without throwing in test mode" {
        $env:PHWRITER_TEST_MODE = 'true'
        try {
            "Line 1", "Line 2" | Invoke-PHPager -Title 'Test Pager' -NoColor
        } finally {
            $env:PHWRITER_TEST_MODE = 'true'
        }
    }

    It "Should render ANSI colorized content in test mode" {
        $env:PHWRITER_TEST_MODE = 'true'
        try {
            "Line 1 with `e[31mRed`e[0m text" | Invoke-PHPager -Title 'Test Color Pager'
        } finally {
            $env:PHWRITER_TEST_MODE = 'true'
        }
    }
}

Context "Cmdlet-Help-Switches" {
    It "Should render help for New-PHWriter without throwing" {
        New-PHWriter -Help
    }

    It "Should render help for Export-PHWriterMetadata without throwing" {
        Export-PHWriterMetadata -Help
    }

    It "Should render help for Show-PHTheme without throwing" {
        Show-PHTheme -Help
    }

    It "Should render help for New-PHRouter without throwing" {
        New-PHRouter -Help
    }

    It "Should render help for Invoke-PHPager without throwing" {
        Invoke-PHPager -Help
    }

    It "Should render help for Write-PHAsciiLogo without throwing" {
        Write-PHAsciiLogo -Help
    }
}

Context "PHWriter-Priority-1-Features" {
    It "Should support Pad-AnsiString with multi-character/emoji PadChar" {
        $padded = Pad-AnsiString -Text "A" -Width 6 -Align 'Center' -PadChar "🔥"
        $padded | Should -BeLike "*🔥A🔥*"
    }

    It "Should support Clap-SliceAnsi to slice styled text preserving colors" {
        $text = "abc`e[31mdef`e[0mghi"
        $sliced = Clap-SliceAnsi -Text $text -Start 3 -Width 3
        $sliced | Should -BeLike "*def*"
        $sliced | Should -Not -BeLike "*abc*"
        $sliced | Should -Not -BeLike "*ghi*"
    }

    It "Should render New-PHWriter with Gradient and OuterBorder without throwing" {
        New-PHWriter @params -Gradient -OuterBorder -BorderGradient
    }

    It "Should render New-PHWriter with CustomGradient steps without throwing" {
        New-PHWriter @params -CustomGradient @(196, 202, 226) -OuterBorder -BorderCustomGradient @(17, 21)
    }

    It "Should render New-PHWriter with -Compact switch (LineSpacing=0) without throwing" {
        New-PHWriter @params -Compact
    }

    It "Should render New-PHWriter with -Compact overriding -LineSpacing without throwing" {
        # -Compact takes precedence — both supplied together should not error
        New-PHWriter @params -Compact -LineSpacing 2
    }
}

Context "Show-PHTheme-Enhancements" {
    It "Should render Show-PHTheme in compact mode without throwing" {
        Show-PHTheme -Name 'default' -Compact
    }

    It "Should render Show-PHTheme with OuterBorder without throwing" {
        Show-PHTheme -Name 'nord' -OuterBorder
    }

    It "Should render Show-PHTheme with Gradient and BorderGradient without throwing" {
        Show-PHTheme -Name 'aurora' -Gradient -OuterBorder -BorderGradient
    }

    It "Should render Show-PHTheme with custom-rgb in minimal mode without throwing" {
        Show-PHTheme -Name 'custom-rgb' -Minimal
    }

    It "Should render Show-PHTheme help without throwing" {
        Show-PHTheme -Help
    }
}

Context "PHWriter-Width-and-Paging-Features" {
    It "Should support Width options ('man', 'full', custom)" {
        $manOut = New-PHWriter @params -Width 'man' -OutMode String
        $manOut | Should -Not -BeNullOrEmpty
        
        $fullOut = New-PHWriter @params -Width 'full' -OutMode String
        $fullOut | Should -Not -BeNullOrEmpty

        $customOut = New-PHWriter @params -Width 60 -OutMode String
        $customOut | Should -Not -BeNullOrEmpty
    }

    It "Should respect minimum width safeguard" {
        $shortOut = New-PHWriter @params -Width 30 -OutMode String
        ($shortOut -join "") | Should -BeLike "*Console width*below the minimum*"
    }

    It "Should support OutMode Auto and Alt without throwing" {
        $env:PHWRITER_TEST_MODE = 'true'
        try {
            New-PHWriter @params -OutMode Alt
            New-PHWriter @params -OutMode Auto
        } finally {
            $env:PHWRITER_TEST_MODE = 'true'
        }
    }
}

Context "New-AsciiTokenGradient-and-Color-Support" {
    BeforeAll {
        . ./Public/New-AsciiTokenGradient.ps1
        . ./Private/ConvertTo-AsciiTokens.ps1
    }

    It "Should tokenize and colorize ASCII art using New-AsciiTokenGradient" {
        $art = @(
            "(\ "
            "\'\ "
            " \'\     __________  "
            " / '|   ()_________)"
            " \ '/    \ ~~~~~~~~ \"
            "   \       \ ~~~~~~   \"
            "   ==).      \__________\"
            "  (__)       ()__________)"
        )
        $outH = New-AsciiTokenGradient -Lines $art -Mode Horizontal
        $outH | Should -Not -BeNullOrEmpty

        $outV = New-AsciiTokenGradient -Lines $art -Mode Vertical
        $outV | Should -Not -BeNullOrEmpty

        $outP = New-AsciiTokenGradient -Lines $art -Mode PerToken
        $outP | Should -Not -BeNullOrEmpty
    }

    It "Should respect NO_COLOR env variable in New-AsciiColor and New-AsciiGradient" {
        $env:NO_COLOR = 'true'
        try {
            $colored = New-AsciiColor -String "Hello" -Color "255;0;0"
            $colored | Should -Be "Hello"

            $gradient = New-AsciiGradient -Type 'fg' -Steps @(16, 20) -String "World"
            $gradient | Should -Be "World"
        } finally {
            $env:NO_COLOR = $null
        }
    }

    It "Should use TrueColor output when truecolor is supported in New-AsciiGradient" {
        $env:COLORTERM = 'truecolor'
        try {
            $gradient = New-AsciiGradient -Type 'fg' -Steps @(16, 20) -String "World"
            # TrueColor escape code starts with \e[38;2;
            $gradient | Should -Match ([regex]::Escape("`e[38;2;"))
        } finally {
            $env:COLORTERM = $null
        }
    }

    It "Should colorize logo using GradientMode (Horizontal, Vertical, PerToken)" {
        $mockTheme = Get-PHTheme -Name 'aurora'
        Write-PHAsciiLogo -Name 'TESTLOGO' -Theme $mockTheme -Layout 'Box' -Gradient -GradientMode Horizontal
        Write-PHAsciiLogo -Name 'TESTLOGO' -Theme $mockTheme -Layout 'Box' -Gradient -GradientMode Vertical
        Write-PHAsciiLogo -Name 'TESTLOGO' -Theme $mockTheme -Layout 'Box' -Gradient -GradientMode PerToken

        Write-PHAsciiLogo -Name 'TESTLOGO' -Theme $mockTheme -Layout 'Terminal' -Gradient -GradientMode Horizontal
        Write-PHAsciiLogo -Name 'TESTLOGO' -Theme $mockTheme -Layout 'Typewriter' -Gradient -GradientMode Horizontal

        $custom = " (\ `n\'\'\ `n \'\     __________"
        Write-PHAsciiLogo -Name 'TESTLOGO' -CustomLogo $custom -Theme $mockTheme -Gradient -GradientMode Vertical
    }

    It "Should support GradientMode in New-PHWriter and Show-PHTheme" {
        $writerOut = New-PHWriter -Name 'TESTWRITER' -OutMode String -Gradient -GradientMode PerToken
        $writerOut | Should -Not -BeNullOrEmpty

        Show-PHTheme -Name 'aurora' -Gradient -GradientMode Vertical -Minimal
    }
}

Context "Documentation-Contract-Test" {
    BeforeAll {
        $docsDir = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, "..", "docs"))
        $apiRefPath = [System.IO.Path]::Combine($docsDir, "api-reference.md")
        $cmdletsYmlPath = [System.IO.Path]::Combine($docsDir, "_data", "cmdlets.yml")
    }

    It "Should have all public cmdlets documented in cmdlets.yml" {
        $module = Get-Module -Name phwriter
        $exportedCmdlets = $module.ExportedFunctions.Keys

        $ymlContent = [System.IO.File]::ReadAllText($cmdletsYmlPath)
        $documentedCmdlets = [System.Text.RegularExpressions.Regex]::Matches($ymlContent, '(?m)^\s*-\s*name:\s*(\S+)') | ForEach-Object { $_.Groups[1].Value }

        foreach ($cmdlet in $exportedCmdlets) {
            $documentedCmdlets | Should -Contain $cmdlet
        }
    }

    It "Should have all cmdlet parameters documented in api-reference.md" {
        $module = Get-Module -Name phwriter
        $exportedCmdlets = $module.ExportedFunctions.Keys
        $apiRefContent = [System.IO.File]::ReadAllText($apiRefPath)

        $commonParams = @(
            'Verbose', 'Debug', 'ErrorAction', 'WarningAction', 'InformationAction',
            'ErrorVariable', 'WarningVariable', 'InformationVariable', 'OutVariable',
            'OutBuffer', 'PipelineVariable', 'WhatIf', 'Confirm', 'UseTransaction',
            'ProgressAction'
        )

        foreach ($cmdlet in $exportedCmdlets) {
            $command = Get-Command -Name $cmdlet -Module phwriter
            $parameters = $command.Parameters.Keys | Where-Object { $_ -notin $commonParams }

            foreach ($param in $parameters) {
                # Look for parameter name formatted as -ParamName in api-reference.md
                $apiRefContent | Should -Match "(?i)-${param}\b"
            }
        }
    }

    It "Should validate all local Markdown links and assets in documentation pages" {
        $mdFiles = [System.IO.Directory]::GetFiles($docsDir, "*.md", [System.IO.SearchOption]::AllDirectories)
        # Avoid vendor directory
        $mdFiles = $mdFiles | Where-Object { $_ -notmatch 'docs/vendor/' }

        foreach ($file in $mdFiles) {
            $content = [System.IO.File]::ReadAllText($file)
            $fileDir = [System.IO.Path]::GetDirectoryName($file)

            # Match markdown links: [text](link) and images: ![alt](link)
            $matches = [System.Text.RegularExpressions.Regex]::Matches($content, '(?i)(?:!\[.*?\]|\[.*?\])\(([^:\)]+?)\)')
            foreach ($match in $matches) {
                $link = $match.Groups[1].Value.Trim()

                # Ignore empty links, web URLs, mailto links, anchor-only links, and Jekyll/Liquid templates
                if ([string]::IsNullOrWhiteSpace($link) -or 
                    $link -match '^(http|https|mailto):' -or 
                    $link -match '^#' -or
                    $link -match '\{\{.*?\}\}' -or
                    $link -match '\{%.*?%\}') {
                    continue
                }

                # Remove query string or anchors if any
                $cleanLink = $link -replace '#.*$', '' -replace '\?.*$', ''
                if ([string]::IsNullOrWhiteSpace($cleanLink)) {
                    continue
                }

                # Resolve local path
                $resolvedPath = $null
                if ($cleanLink.StartsWith("/")) {
                    # Relative to Jekyll site root (docs/)
                    $resolvedPath = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($docsDir, $cleanLink.TrimStart("/")))
                } else {
                    # Relative to the current markdown file's directory
                    $resolvedPath = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($fileDir, $cleanLink))
                }

                # Assert that the file or directory exists (mapping .html to .md if needed)
                $exists = [System.IO.File]::Exists($resolvedPath) -or [System.IO.Directory]::Exists($resolvedPath)
                if (-not $exists -and $resolvedPath -match '\.html$') {
                    $mdPath = $resolvedPath -replace '\.html$', '.md'
                    $exists = [System.IO.File]::Exists($mdPath)
                }
                if (-not $exists) {
                    Write-Error "Broken link in '$file': '$link' (resolved to '$resolvedPath')"
                }
                $exists | Should -Be $true
            }
        }
    }

    It "Should not contain superseded parameter examples or copied package names" {
        $readme = [System.IO.File]::ReadAllText([System.IO.Path]::Combine($PSScriptRoot, '..', 'README.md'))
        $metadataPage = [System.IO.File]::ReadAllText([System.IO.Path]::Combine($PSScriptRoot, '..', 'docs', 'metadata-extraction.md'))
        $routerPage = [System.IO.File]::ReadAllText([System.IO.Path]::Combine($PSScriptRoot, '..', 'docs', 'cli-routing.md'))

        $readme | Should -Not -Match 'commitfusion|Export-PHWriterMetadata -FilePath'
        $metadataPage | Should -Not -Match 'Export-PHWriterMetadata -FilePath'
        $routerPage | Should -Not -Match 'New-PHRouter -Routes \$Routes -Args'
    }
}
}
