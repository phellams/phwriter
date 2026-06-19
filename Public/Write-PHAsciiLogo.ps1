function _Measure-VisualWidth {
    <#
    .SYNOPSIS
      Returns the display-column-width of a plain or ANSI-escaped string.
    .DESCRIPTION
      Strips ANSI SGR sequences first, then iterates each char and adds 2 for wide
      Unicode codepoints (emoji block U+1F300-U+1FAFF, misc symbols U+2600-U+27BF,
      CJK compatibility U+FE30-U+FE4F, CJK unified U+4E00-U+9FFF) and 1 for all
      other characters.  Handles .NET surrogate pairs correctly.
    #>
    param([string]$Text)
    # Strip ANSI SGR sequences
    $plain = [System.Text.RegularExpressions.Regex]::Replace(
        $Text, '\x1b\[[0-?]*[ -/]*[@-~]', '')
    $width = 0
    $chars = $plain.ToCharArray()
    $i = 0
    while ($i -lt $chars.Length) {
        $ch = $chars[$i]
        # Detect surrogate pair — high surrogate followed by low surrogate
        if ([char]::IsHighSurrogate($ch) -and ($i + 1) -lt $chars.Length -and [char]::IsLowSurrogate($chars[$i + 1])) {
            $cp = [char]::ConvertToUtf32($ch, $chars[$i + 1])
            # Emoji + supplemental symbols: U+1F000–U+1FAFF
            if ($cp -ge 0x1F000 -and $cp -le 0x1FAFF) {
                $width += 2
            } else {
                $width += 2  # any other supplementary char defaults wide
            }
            $i += 2
            continue
        }
        $cp = [int]$ch
        if (($cp -ge 0x1F300 -and $cp -le 0x1FAFF) -or   # Emoji / supplemental symbols (BMP subset)
            ($cp -ge 0x2600  -and $cp -le 0x27BF)  -or   # Miscellaneous symbols
            ($cp -ge 0xFE30  -and $cp -le 0xFE4F)  -or   # CJK compatibility forms
            ($cp -ge 0x4E00  -and $cp -le 0x9FFF)) {      # CJK unified ideographs
            $width += 2
        } else {
            $width += 1
        }
        $i++
    }
    return $width
}

function Write-PHAsciiLogo {
    <#
    .SYNOPSIS
      Renders the ASCII logo banner for a module with dynamic theme and layout options.
    .DESCRIPTION
      Renders a stylized ASCII/ANSI header banner using selected theme colors and layout styles.
    .PARAMETER Name
      The name of the module to display.
    .PARAMETER Version
      Optional version string of the module.
    .PARAMETER Theme
      A theme name string ('default', 'matrix', 'cyberpunk', etc.) or a custom theme hashtable.
    .PARAMETER Layout
      The layout style to use: 'Box', 'Classic', 'Minimal', 'Man', 'Terminal', 'Typewriter'.
    .PARAMETER CustomLogo
      An optional custom ASCII art string that overrides the default layouts.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Name,

        [Parameter(Position = 1)]
        [string]$Version = '',

        [Parameter()]
        $Theme = 'default',

        [Parameter()]
        [ValidateSet('Box', 'Classic', 'Minimal', 'Man', 'Terminal', 'Typewriter')]
        [string]$Layout = 'Box',

        [Parameter()]
        [string]$CustomLogo = $null
    )

    process {
        # Resolve Theme
        $themeObj = $null
        if ($Theme -is [hashtable]) {
            $themeObj = $Theme
        } else {
            $themeObj = Get-PHTheme -Name $Theme
        }

        # If custom logo is provided, print it directly (with border styling applied to each line if wanted)
        if ($CustomLogo) {
            $lines = $CustomLogo -split "`n" | ForEach-Object { $_.TrimEnd() }
            foreach ($line in $lines) {
                [console]::WriteLine($(Format-ThemeText -String $line -Theme $themeObj -Element 'Border'))
            }
            [console]::Write("`n")
            return
        }

        # Format spaced name (e.g. "P H W R I T E R")
        $spacedName = Format-StringWithCharSpacesAndHyphens -InputString $Name
        $versionStr = if ($Version) { "v$Version" } else { "" }

        switch ($Layout) {
            'Box' {
                $nameVisualWidth = _Measure-VisualWidth $spacedName
                $width  = [Math]::Max(60, $nameVisualWidth + 8)
                $top    = "╭" + ("─" * ($width - 2)) + "╮"
                $bottom = "╰" + ("─" * ($width - 2)) + "╯"

                # $width includes the two │ chars; inner usable columns = $width - 2.
                # We reserve 1 space minimum on each side, so available padding = inner - nameWidth - 2.
                $innerWidth   = $width - 2
                $paddingTotal = $innerWidth - $nameVisualWidth - 2
                $padLeft  = [Math]::Max(1, [Math]::Floor($paddingTotal / 2))
                $padRight = [Math]::Max(1, $paddingTotal - $padLeft)

                $middle = "│" + (" " * $padLeft) + $spacedName + (" " * $padRight) + "│"

                [console]::WriteLine($(Format-ThemeText -String $top    -Theme $themeObj -Element 'Border'))
                [console]::WriteLine($(Format-ThemeText -String $middle -Theme $themeObj -Element 'Header'))
                [console]::WriteLine($(Format-ThemeText -String $bottom -Theme $themeObj -Element 'Border'))
            }
            'Classic' {
                # Renders the original classic double-line banner styled by the theme parameters
                $borderTop    = $themeObj['BorderTop']
                $borderBottom = $themeObj['BorderBottom']
                $borderMiddle = $themeObj['BorderMiddle']

                # Compute padding based on visual width of BorderTop (handles emoji/wide chars)
                $totalWidth = if ($borderTop) { _Measure-VisualWidth $borderTop } else { 70 }

                $paddingTotal = $totalWidth - $nameVisualWidth - 4
                $padLeft  = [Math]::Max(0, [Math]::Floor($paddingTotal / 2))
                $padRight = [Math]::Max(0, $paddingTotal - $padLeft)

                $middleChar = if ($borderMiddle) { $borderMiddle } else { "░" }
                $nameVisualWidth = _Measure-VisualWidth $spacedName
                $middle = "╟" + ($middleChar * $padLeft) + $spacedName + ($middleChar * $padRight) + "╢"

                [console]::WriteLine($(Format-ThemeText -String $borderTop    -Theme $themeObj -Element 'Border'))
                [console]::WriteLine($(Format-ThemeText -String $middle        -Theme $themeObj -Element 'Header'))
                [console]::WriteLine($(Format-ThemeText -String $borderBottom  -Theme $themeObj -Element 'Border'))
            }
            'Minimal' {
                $nameVisualWidth = _Measure-VisualWidth $spacedName
                $width = [Math]::Max(60, $nameVisualWidth + 4)
                $line  = "─" * $width
                [console]::WriteLine($(Format-ThemeText -String ("  " + $spacedName) -Theme $themeObj -Element 'Header'))
                [console]::WriteLine($(Format-ThemeText -String $line -Theme $themeObj -Element 'Border'))
            }
            'Man' {
                # Mimics a standard Linux man header: PHWRITER(1)   User Commands   PHWRITER(1)
                $width      = 70
                $leftText   = "$($Name.ToUpper())(1)"
                $centerText = "User Commands"
                $rightText  = "$($Name.ToUpper())(1)"

                $padSize    = [Math]::Max(2, [Math]::Floor(($width - $leftText.Length - $centerText.Length - $rightText.Length) / 2))
                $headerLine = $leftText + (" " * $padSize) + $centerText + (" " * $padSize) + $rightText

                [console]::WriteLine($(Format-ThemeText -String $headerLine -Theme $themeObj -Element 'Header'))
                [console]::WriteLine($(Format-ThemeText -String ("─" * $width) -Theme $themeObj -Element 'Border'))
            }
            'Terminal' {
                $terminalArt = @(
                    "   ┌───────────────┐",
                    "   │  >_           │      {Name}",
                    "   │               │",
                    "   │               │      {Version}",
                    "   └───────────────┘"
                )

                foreach ($line in $terminalArt) {
                    $rendered = $line
                    if ($rendered -match '\{Name\}') {
                        $styledName = Format-ThemeText -String $spacedName -Theme $themeObj -Element 'Header'
                        $rendered   = $rendered -replace '\{Name\}', $styledName
                    }
                    if ($rendered -match '\{Version\}') {
                        $styledVer = Format-ThemeText -String $versionStr -Theme $themeObj -Element 'Version'
                        $rendered  = $rendered -replace '\{Version\}', $styledVer
                    }

                    # Highlight the terminal icon borders/text
                    $boxPart  = $rendered.Substring(0, 20)
                    $textPart = if ($rendered.Length -gt 20) { $rendered.Substring(20) } else { "" }

                    $styledBox = Format-ThemeText -String $boxPart -Theme $themeObj -Element 'Border'
                    [console]::WriteLine($styledBox + $textPart)
                }
            }
            'Typewriter' {
                $typewriterArt = @(
                    "    .───────────────────.",
                    "   │  _________________  │      {Name}",
                    "   │ ░░░░░░░░░░░░░░░░░  │",
                    "   │ ░░░░░░░░░░░░░░░░░  │      {Version}",
                    "   │  ─────────────────  │",
                    "   │ [a][s][d][f][g][h]  │",
                    "   │ [z][x][c][v][b][n]  │",
                    "   '───────────────────'"
                )

                foreach ($line in $typewriterArt) {
                    $rendered = $line
                    if ($rendered -match '\{Name\}') {
                        $styledName = Format-ThemeText -String $spacedName -Theme $themeObj -Element 'Header'
                        $rendered   = $rendered -replace '\{Name\}', $styledName
                    }
                    if ($rendered -match '\{Version\}') {
                        $styledVer = Format-ThemeText -String $versionStr -Theme $themeObj -Element 'Version'
                        $rendered  = $rendered -replace '\{Version\}', $styledVer
                    }

                    $boxPart  = $rendered.Substring(0, 24)
                    $textPart = if ($rendered.Length -gt 24) { $rendered.Substring(24) } else { "" }

                    $styledBox = Format-ThemeText -String $boxPart -Theme $themeObj -Element 'Border'
                    [console]::WriteLine($styledBox + $textPart)
                }
            }
        }
        [console]::Write("`n")
    }
}
