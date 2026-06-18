function Get-PHTheme {
    <#
    .SYNOPSIS
      Retrieve a predefined theme configuration by name.
    .DESCRIPTION
      Returns a hashtable defining terminal colors, styles, borders and layouts.
    .PARAMETER Name
      Name of the theme. Default is 'default'.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]$Name = 'default'
    )

    $Themes = @{
        'default' = @{
            AccentColor      = 'darkgreen'
            AccentFormat     = 'bold,italic'
            BorderColor      = 'darkgreen'
            BorderFormat     = 'bold'
            HeaderBg         = 'gray'
            HeaderFg         = 'cyan'
            ModuleBg         = 'gray'
            ModuleFg         = 'cyan'
            VersionBg        = 'gray'
            VersionFg        = 'darkmagenta'
            SyntaxFg         = 'white'
            SyntaxFormat     = 'none'
            DescriptionFg    = 'white'
            ParamNameFg      = 'darkmagenta'
            ParamNameFormat  = 'none'
            ParamTypeFg      = 'darkcyan'
            ParamTypeFormat  = 'none'
            ParamReqFg       = 'red'
            ParamReqFormat   = 'bold'
            ParamDescFg      = 'gray'
            ExampleFg        = 'gray'
            DocsFg           = 'darkcyan'
            DocsFormat       = 'bold,underline'
            SectionChar      = '◉'
            HeaderChar       = '▶'
            BorderTop        = '▫▫▫▫▫▫▫▫════════════════════════════════════════════════════════▫▫▫▫▫▫═╗'
            BorderBottom     = '▫▫▫▫▫▫▫▫════════════════════════════════════════════════════════▫▫▫▫▫▫═╝'
            BorderMiddle     = '░'
        }
        'matrix' = @{
            AccentColor      = 'green'
            AccentFormat     = 'bold'
            BorderColor      = 'green'
            BorderFormat     = 'bold'
            HeaderBg         = 'black'
            HeaderFg         = 'green'
            ModuleBg         = 'black'
            ModuleFg         = 'green'
            VersionBg        = 'black'
            VersionFg        = 'green'
            SyntaxFg         = 'green'
            SyntaxFormat     = 'none'
            DescriptionFg    = 'green'
            ParamNameFg      = 'green'
            ParamNameFormat  = 'bold'
            ParamTypeFg      = 'green'
            ParamTypeFormat  = 'italic'
            ParamReqFg       = 'green'
            ParamReqFormat   = 'reverse'
            ParamDescFg      = 'gray'
            ExampleFg        = 'green'
            DocsFg           = 'green'
            DocsFormat       = 'underline'
            SectionChar      = '$'
            HeaderChar       = '>'
            BorderTop        = '┌────────────────────────────────────────────────────────┐'
            BorderBottom     = '└────────────────────────────────────────────────────────┘'
            BorderMiddle     = ' '
        }
        'cyberpunk' = @{
            AccentColor      = 'magenta'
            AccentFormat     = 'bold'
            BorderColor      = 'cyan'
            BorderFormat     = 'bold'
            HeaderBg         = 'black'
            HeaderFg         = 'yellow'
            ModuleBg         = 'black'
            ModuleFg         = 'magenta'
            VersionBg        = 'black'
            VersionFg        = 'cyan'
            SyntaxFg         = 'white'
            SyntaxFormat     = 'none'
            DescriptionFg    = 'yellow'
            ParamNameFg      = 'magenta'
            ParamNameFormat  = 'bold'
            ParamTypeFg      = 'cyan'
            ParamTypeFormat  = 'none'
            ParamReqFg       = 'red'
            ParamReqFormat   = 'bold'
            ParamDescFg      = 'gray'
            ExampleFg        = 'cyan'
            DocsFg           = 'yellow'
            DocsFormat       = 'bold,underline'
            SectionChar      = '▲'
            HeaderChar       = '»'
            BorderTop        = '⚡════════════════════════════════════════════════════════════⚡'
            BorderBottom     = '⚡════════════════════════════════════════════════════════════⚡'
            BorderMiddle     = '░'
        }
        'dracula' = @{
            AccentColor      = 'magenta'
            AccentFormat     = 'bold'
            BorderColor      = 'magenta'
            BorderFormat     = 'none'
            HeaderBg         = 'black'
            HeaderFg         = 'blue'
            ModuleBg         = 'black'
            ModuleFg         = 'blue'
            VersionBg        = 'black'
            VersionFg        = 'yellow'
            SyntaxFg         = 'white'
            SyntaxFormat     = 'none'
            DescriptionFg    = 'green'
            ParamNameFg      = 'magenta'
            ParamNameFormat  = 'none'
            ParamTypeFg      = 'cyan'
            ParamTypeFormat  = 'italic'
            ParamReqFg       = 'red'
            ParamReqFormat   = 'bold'
            ParamDescFg      = 'gray'
            ExampleFg        = 'yellow'
            DocsFg           = 'cyan'
            DocsFormat       = 'underline'
            SectionChar      = '🧛'
            HeaderChar       = '→'
            BorderTop        = '░░░░▒▒▒▒▓▓▓▓───────────────────────────────────▓▓▓▓▒▒▒▒░░░░'
            BorderBottom     = '░░░░▒▒▒▒▓▓▓▓───────────────────────────────────▓▓▓▓▒▒▒▒░░░░'
            BorderMiddle     = '🦇'
        }
        'nord' = @{
            AccentColor      = 'blue'
            AccentFormat     = 'bold'
            BorderColor      = 'darkblue'
            BorderFormat     = 'none'
            HeaderBg         = 'gray'
            HeaderFg         = 'white'
            ModuleBg         = 'gray'
            ModuleFg         = 'cyan'
            VersionBg        = 'gray'
            VersionFg        = 'blue'
            SyntaxFg         = 'white'
            SyntaxFormat     = 'none'
            DescriptionFg    = 'white'
            ParamNameFg      = 'blue'
            ParamNameFormat  = 'bold'
            ParamTypeFg      = 'cyan'
            ParamTypeFormat  = 'none'
            ParamReqFg       = 'red'
            ParamReqFormat   = 'none'
            ParamDescFg      = 'gray'
            ExampleFg        = 'cyan'
            DocsFg           = 'blue'
            DocsFormat       = 'underline'
            SectionChar      = '❄'
            HeaderChar       = '›'
            BorderTop        = '❄────────────────────────────────────────────────────────❄'
            BorderBottom     = '❄────────────────────────────────────────────────────────❄'
            BorderMiddle     = '·'
        }
        'monokai' = @{
            AccentColor      = 'green'
            AccentFormat     = 'bold'
            BorderColor      = 'yellow'
            BorderFormat     = 'none'
            HeaderBg         = 'black'
            HeaderFg         = 'magenta'
            ModuleBg         = 'black'
            ModuleFg         = 'magenta'
            VersionBg        = 'black'
            VersionFg        = 'yellow'
            SyntaxFg         = 'white'
            SyntaxFormat     = 'none'
            DescriptionFg    = 'white'
            ParamNameFg      = 'magenta'
            ParamNameFormat  = 'bold'
            ParamTypeFg      = 'cyan'
            ParamTypeFormat  = 'italic'
            ParamReqFg       = 'red'
            ParamReqFormat   = 'bold'
            ParamDescFg      = 'gray'
            ExampleFg        = 'yellow'
            DocsFg           = 'green'
            DocsFormat       = 'underline'
            SectionChar      = '❖'
            HeaderChar       = '»'
            BorderTop        = '==========================================================='
            BorderBottom     = '==========================================================='
            BorderMiddle     = ' '
        }
        'solarized' = @{
            AccentColor      = 'cyan'
            AccentFormat     = 'bold'
            BorderColor      = 'blue'
            BorderFormat     = 'none'
            HeaderBg         = 'black'
            HeaderFg         = 'yellow'
            ModuleBg         = 'black'
            ModuleFg         = 'cyan'
            VersionBg        = 'black'
            VersionFg        = 'magenta'
            SyntaxFg         = 'white'
            SyntaxFormat     = 'none'
            DescriptionFg    = 'gray'
            ParamNameFg      = 'blue'
            ParamNameFormat  = 'none'
            ParamTypeFg      = 'green'
            ParamTypeFormat  = 'none'
            ParamReqFg       = 'red'
            ParamReqFormat   = 'bold'
            ParamDescFg      = 'gray'
            ExampleFg        = 'green'
            DocsFg           = 'cyan'
            DocsFormat       = 'underline'
            SectionChar      = '☼'
            HeaderChar       = '☞'
            BorderTop        = '☼────────────────────────────────────────────────────────☼'
            BorderBottom     = '☼────────────────────────────────────────────────────────☼'
            BorderMiddle     = ' '
        }
        'sunset' = @{
            AccentColor      = 'red'
            AccentFormat     = 'bold'
            BorderColor      = 'yellow'
            BorderFormat     = 'bold'
            HeaderBg         = 'gray'
            HeaderFg         = 'red'
            ModuleBg         = 'gray'
            ModuleFg         = 'yellow'
            VersionBg        = 'gray'
            VersionFg        = 'magenta'
            SyntaxFg         = 'white'
            SyntaxFormat     = 'none'
            DescriptionFg    = 'yellow'
            ParamNameFg      = 'red'
            ParamNameFormat  = 'bold'
            ParamTypeFg      = 'yellow'
            ParamTypeFormat  = 'none'
            ParamReqFg       = 'red'
            ParamReqFormat   = 'bold'
            ParamDescFg      = 'gray'
            ExampleFg        = 'yellow'
            DocsFg           = 'red'
            DocsFormat       = 'underline'
            SectionChar      = '🌅'
            HeaderChar       = '➔'
            BorderTop        = '🌅━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━🌅'
            BorderBottom     = '🌅━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━🌅'
            BorderMiddle     = '▒'
        }
        'forest' = @{
            AccentColor      = 'darkgreen'
            AccentFormat     = 'bold'
            BorderColor      = 'green'
            BorderFormat     = 'none'
            HeaderBg         = 'black'
            HeaderFg         = 'green'
            ModuleBg         = 'black'
            ModuleFg         = 'darkgreen'
            VersionBg        = 'black'
            VersionFg        = 'yellow'
            SyntaxFg         = 'white'
            SyntaxFormat     = 'none'
            DescriptionFg    = 'gray'
            ParamNameFg      = 'green'
            ParamNameFormat  = 'bold'
            ParamTypeFg      = 'darkyellow'
            ParamTypeFormat  = 'italic'
            ParamReqFg       = 'red'
            ParamReqFormat   = 'bold'
            ParamDescFg      = 'gray'
            ExampleFg        = 'green'
            DocsFg           = 'darkgreen'
            DocsFormat       = 'underline'
            SectionChar      = '🌲'
            HeaderChar       = '🌿'
            BorderTop        = '🌲━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━🌲'
            BorderBottom     = '🌲━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━🌲'
            BorderMiddle     = '✿'
        }
        'classic' = @{
            AccentColor      = 'white'
            AccentFormat     = 'bold,underline'
            BorderColor      = 'white'
            BorderFormat     = 'none'
            HeaderBg         = ''
            HeaderFg         = 'white'
            ModuleBg         = ''
            ModuleFg         = 'white'
            VersionBg        = ''
            VersionFg        = 'white'
            SyntaxFg         = 'white'
            SyntaxFormat     = 'none'
            DescriptionFg    = 'white'
            ParamNameFg      = 'white'
            ParamNameFormat  = 'bold'
            ParamTypeFg      = 'white'
            ParamTypeFormat  = 'underline'
            ParamReqFg       = 'white'
            ParamReqFormat   = 'bold'
            ParamDescFg      = 'white'
            ExampleFg        = 'white'
            DocsFg           = 'white'
            DocsFormat       = 'underline'
            SectionChar      = ''
            HeaderChar       = ''
            BorderTop        = '------------------------------------------------------------'
            BorderBottom     = '------------------------------------------------------------'
            BorderMiddle     = ' '
        }
    }

    $selected = $Name.ToLower()
    if ($Themes.ContainsKey($selected)) {
        return $Themes[$selected]
    }
    return $Themes['default']
}

function Format-ThemeText {
    param(
        [string]$String,
        [hashtable]$Theme,
        [string]$Element
    )
    if ([string]::IsNullOrEmpty($String)) { return '' }
    
    $colorKey = "${Element}Fg"
    $bgKey = "${Element}Bg"
    $formatKey = "${Element}Format"
    
    $color = if ($Theme.ContainsKey($colorKey)) { $Theme[$colorKey] } else { '' }
    $bgColor = if ($Theme.ContainsKey($bgKey)) { $Theme[$bgKey] } else { '' }
    
    $rawFormat = if ($Theme.ContainsKey($formatKey)) { 
        if ($Theme[$formatKey] -is [array]) { $Theme[$formatKey] } 
        else { $Theme[$formatKey] -split ',' }
    } else { @() }
    
    $format = @($rawFormat) | Where-Object { $_ -and $_ -ne 'none' }

    $params = @{
        String = $String
        Color  = $color
        BgColor = $bgColor
    }
    if ($format -and $format.Count -gt 0) {
        $params['Format'] = $format
    }
    
    return New-AsciiColor @params
}
