function Show-PHTheme {
    <#
    .SYNOPSIS
      Displays a visual preview of one or all PHWriter themes.
    .DESCRIPTION
      Renders mock cmdlet help text and banner logos using the specified theme
      and layout, providing developers with a direct terminal preview of the themes.
      Supports showcasing custom RGB / true-color palettes.
    .PARAMETER Name
      Name of the theme to preview (e.g. 'default', 'cyberpunk', 'aurora').
      Set to 'all' or use the -All switch to preview all themes.
      Set to 'custom-rgb' to preview a dynamically generated RGB true-color theme.
      Default is 'default'.
    .PARAMETER Layout
      The ASCII banner layout style: 'Box', 'Classic', 'Minimal', 'Man', 'Terminal', 'Typewriter'.
      Default is 'Box'.
    .PARAMETER All
      Switch to display previews for all predefined themes.
    .PARAMETER Minimal
      Switch to render only the ASCII banner logo and version header rather than full cmdlet help.
    .EXAMPLE
      Show-PHTheme -Name 'cyberpunk'
      Previews the 'cyberpunk' theme with the default 'Box' layout.
    .EXAMPLE
      Show-PHTheme -All -Layout 'Terminal' -Minimal
      Previews all 41 themes using the 'Terminal' layout in minimal mode.
    .EXAMPLE
      Show-PHTheme -Name 'custom-rgb' -Layout 'Classic'
      Previews a custom RGB/TrueColor theme using the 'Classic' banner layout.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, ValueFromPipeline = $true)]
        [ValidateSet(
                'default', 'matrix', 'cyberpunk', 'dracula', 'nord', 'monokai', 'solarized', 
                'sunset', 'forest', 'classic', 'aurora', 'neon-noir', 'lava', 'ocean', 'toxic', 
                'midnight', 'gold', 'rose', 'steel', 'phwriter', 'glitch', 'cosmic', 
                'forest-mist', 'blood-moon', 'retro-arcade', 'abyss', 'zen', 'blaze', 'rust', 
                'matrix-neon', 'quantum', 'radioactive', 'vaporwave', 'nebula', 'crystal', 
                'copper', 'royal', 'desert-heat', 'sheriff', 'frost'
        )]
        [string]$Name = 'default',

        [Parameter()]
        [ValidateSet('Box', 'Classic', 'Minimal', 'Man', 'Terminal', 'Typewriter')]
        [string]$Layout = 'Box',

        [Parameter()]
        [switch]$All,

        [Parameter()]
        [switch]$Minimal,

        [Parameter(HelpMessage = "Display Help for Show-PHTheme.")]
        [switch]$Help
    )

    begin {
        $mockCommandInfo = @{
            cmdlet      = "Get-SampleCmdlet"
            synopsis    = "Get-SampleCmdlet [-Path <String>] [-Force] [-Verbose]"
            description = "This sample cmdlet retrieves configuration data and performs basic validation checks. It is formatted to show the colors and layouts of the theme."
            source      = "https://gitlab.com/phellams/phwriter"
        }

        $mockParams = @(
            @{
                name        = "Path"
                param       = "p|Path"
                type        = "String"
                description = "Specifies the filesystem path to the target config file."
                required    = $true
                inline      = $false
            },
            @{
                name        = "Force"
                param       = "f|Force"
                type        = "Switch"
                description = "Force the operation to complete without prompting."
                required    = $false
                inline      = $true
            }
        )

        $mockExamples = @(
            "Get-SampleCmdlet -Path 'config.json' -Force",
            "Get-SampleCmdlet -Path '/etc/app/config.json' -Verbose"
        )
    }

    process {
        if ($Help) {
            $showtheme_ParamTable = @(
                @{
                    name        = "Name"
                    param       = "n|Name"
                    type        = "String"
                    description = "Name of the theme to preview, or 'all', or 'custom-rgb'."
                    required    = $false
                    inline      = $false
                },
                @{
                    name        = "Layout"
                    param       = "l|Layout"
                    type        = "String"
                    description = "The ASCII banner layout style: 'Box', 'Classic', etc."
                    required    = $false
                    inline      = $false
                },
                @{
                    name        = "All"
                    param       = "a|All"
                    type        = "Switch"
                    description = "Preview all themes."
                    required    = $false
                    inline      = $true
                },
                @{
                    name        = "Minimal"
                    param       = "m|Minimal"
                    type        = "Switch"
                    description = "Render only the ASCII banner logo and version header."
                    required    = $false
                    inline      = $true
                }
            )
            $showtheme_commandinfo = @{
                cmdlet      = "Show-PHTheme"
                synopsis    = "Show-PHTheme [-Name <String>] [-Layout <String>] [-All] [-Minimal]"
                description = "Displays a visual preview of one or all PHWriter themes."
                source      = "https://gitlab.com/phellams/phwriter"
            }
            $showtheme_examples = @(
                "Show-PHTheme -Name 'cyberpunk'",
                "Show-PHTheme -All -Layout 'Terminal' -Minimal"
            )
            New-PHWriter -Name 'PHWRITER' -CommandInfo $showtheme_commandinfo -ParamTable $showtheme_ParamTable -Padding 4 -Indent 2 -Theme 'default' -Version '1.0.0' -Examples $showtheme_examples
            return
        }

        # Determine which themes to show
        $themesToShow = @()
        $isCustomRgb = $false

        if ($All -or $Name -eq 'all') {
            # List of all unique predefined themes
            $themesToShow = @(
                'default', 'matrix', 'cyberpunk', 'dracula', 'nord', 'monokai', 'solarized', 
                'sunset', 'forest', 'classic', 'aurora', 'neon-noir', 'lava', 'ocean', 'toxic', 
                'midnight', 'gold', 'rose', 'steel', 'phwriter', 'glitch', 'cosmic', 
                'forest-mist', 'blood-moon', 'retro-arcade', 'abyss', 'zen', 'blaze', 'rust', 
                'matrix-neon', 'quantum', 'radioactive', 'vaporwave', 'nebula', 'crystal', 
                'copper', 'royal', 'desert-heat', 'sheriff', 'frost'
            )
        } elseif ($Name -eq 'custom-rgb') {
            $isCustomRgb = $true
            $themesToShow = @('custom-rgb')
        } else {
            $themesToShow = @($Name)
        }

        foreach ($themeName in $themesToShow) {
            $esc = [char]27
            $reset = "$esc[0m"
            [console]::WriteLine("`n$esc[1;4mTheme Preview: $themeName$reset`n")

            $themeObj = $null
            if ($isCustomRgb) {
                # Showcase dynamic RGB / TrueColor palette
                $themeObj = @{
                    AccentColor      = '255;128;0'       # Orange RGB (r;g;b)
                    AccentFormat     = 'bold'
                    BorderColor      = '0;255;128'       # Spring Green RGB
                    BorderFormat     = 'bold'
                    HeaderBg         = '38;2;16;16;32'   # Very dark blue background
                    HeaderFg         = '0;255;255'       # Cyan RGB
                    ModuleBg         = '38;2;16;16;32'
                    ModuleFg         = '255;0;255'       # Magenta RGB
                    VersionBg         = '38;2;16;16;32'
                    VersionFg        = '255;255;0'       # Yellow RGB
                    SyntaxFg         = '255;255;255'     # White RGB
                    SyntaxFormat     = 'none'
                    DescriptionFg    = '200;200;200'     # Light Grey RGB
                    ParamNameFg      = '0;128;255'       # Sky Blue RGB
                    ParamNameFormat  = 'bold'
                    ParamTypeFg      = '0;255;255'       # Cyan RGB
                    ParamTypeFormat  = 'italic'
                    ParamReqFg       = '255;0;0'         # Red RGB
                    ParamReqFormat   = 'bold,reverse'
                    ParamDescFg      = '150;150;150'     # Grey RGB
                    ExampleFg        = '255;255;0'       # Yellow RGB
                    DocsFg           = '0;255;128'       # Spring Green RGB
                    DocsFormat       = 'underline'
                    SectionChar      = '⚡'
                    HeaderChar       = '»'
                    BorderTop        = '⚡════════════════════════════════════════════════════════════⚡'
                    BorderBottom     = '⚡════════════════════════════════════════════════════════════⚡'
                    BorderMiddle     = '░'
                }
            } else {
                $themeObj = Get-PHTheme -Name $themeName
            }

            if ($Minimal) {
                # Render only the logo and the version header
                Write-PHAsciiLogo -Name 'SAMPLE' -Version '1.0.0' -Theme $themeObj -Layout $Layout
                
                # Render metadata line
                $sectionChar = if ($themeObj.ContainsKey('SectionChar')) { $themeObj['SectionChar'] } else { '◉' }
                $headerChar = if ($themeObj.ContainsKey('HeaderChar')) { $themeObj['HeaderChar'] } else { '▶' }
                $styledHeadChar = if ($headerChar) { Format-ThemeText -String " $headerChar " -Theme $themeObj -Element 'Accent' } else { " " }
                
                $headerParts = @()
                $headerParts += "$(Format-ThemeText -String 'MODULE' -Theme $themeObj -Element 'Accent') $(Format-ThemeText -String 'SAMPLE' -Theme $themeObj -Element 'Header')"
                $headerParts += "$(Format-ThemeText -String 'CMDLET' -Theme $themeObj -Element 'Accent') $(Format-ThemeText -String 'Get-SampleCmdlet' -Theme $themeObj -Element 'Header')"
                $headerParts += "$(Format-ThemeText -String 'VERSION' -Theme $themeObj -Element 'Accent') $(Format-ThemeText -String 'v1.0.0' -Theme $themeObj -Element 'Version')"
                
                [console]::WriteLine(" " + ($headerParts -join $styledHeadChar))
                [console]::WriteLine("─" * 70)
            } else {
                # Full cmdlet preview using New-PHWriter
                New-PHWriter -Name 'SAMPLE' -Version '1.0.0' -CommandInfo $mockCommandInfo -ParamTable $mockParams -Examples $mockExamples -Theme $themeObj -Layout $Layout
            }
            [console]::WriteLine()
        }
    }
}
