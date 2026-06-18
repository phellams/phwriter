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
                $width = [Math]::Max(60, $spacedName.Length + 8)
                $top = "╭" + ("─" * ($width - 2)) + "╮"
                $bottom = "╰" + ("─" * ($width - 2)) + "╯"
                
                $paddingTotal = $width - $spacedName.Length - 4
                $padLeft = [Math]::Floor($paddingTotal / 2)
                $padRight = $paddingTotal - $padLeft
                
                $middle = "│" + (" " * $padLeft) + $spacedName + (" " * $padRight) + "│"

                [console]::WriteLine($(Format-ThemeText -String $top -Theme $themeObj -Element 'Border'))
                [console]::WriteLine($(Format-ThemeText -String $middle -Theme $themeObj -Element 'Header'))
                [console]::WriteLine($(Format-ThemeText -String $bottom -Theme $themeObj -Element 'Border'))
            }
            'Classic' {
                # Renders the original classic double-line banner styled by the theme parameters
                $borderTop = $themeObj['BorderTop']
                $borderBottom = $themeObj['BorderBottom']
                $borderMiddle = $themeObj['BorderMiddle']

                # Compute padding based on BorderTop width (defaulting to 70 if not specified)
                $totalWidth = if ($borderTop) { $borderTop.Length } else { 70 }
                
                $paddingTotal = $totalWidth - $spacedName.Length - 4
                $padLeft = [Math]::Max(0, [Math]::Floor($paddingTotal / 2))
                $padRight = [Math]::Max(0, $paddingTotal - $padLeft)

                $middleChar = if ($borderMiddle) { $borderMiddle } else { "░" }
                $middle = "╟" + ($middleChar * $padLeft) + $spacedName + ($middleChar * $padRight) + "╢"

                [console]::WriteLine($(Format-ThemeText -String $borderTop -Theme $themeObj -Element 'Border'))
                [console]::WriteLine($(Format-ThemeText -String $middle -Theme $themeObj -Element 'Header'))
                [console]::WriteLine($(Format-ThemeText -String $borderBottom -Theme $themeObj -Element 'Border'))
            }
            'Minimal' {
                $width = [Math]::Max(60, $spacedName.Length + 4)
                $line = "─" * $width
                [console]::WriteLine($(Format-ThemeText -String ("  " + $spacedName) -Theme $themeObj -Element 'Header'))
                [console]::WriteLine($(Format-ThemeText -String $line -Theme $themeObj -Element 'Border'))
            }
            'Man' {
                # Mimics a standard Linux man header: PHWRITER(1)   User Commands   PHWRITER(1)
                $width = 70
                $leftText = "$($Name.ToUpper())(1)"
                $centerText = "User Commands"
                $rightText = "$($Name.ToUpper())(1)"
                
                $padSize = [Math]::Max(2, [Math]::Floor(($width - $leftText.Length - $centerText.Length - $rightText.Length) / 2))
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
                        $rendered = $rendered -replace '\{Name\}', $styledName
                    }
                    if ($rendered -match '\{Version\}') {
                        $styledVer = Format-ThemeText -String $versionStr -Theme $themeObj -Element 'Version'
                        $rendered = $rendered -replace '\{Version\}', $styledVer
                    }
                    
                    # Highlight the terminal icon borders/text
                    $boxPart = $rendered.Substring(0, 20)
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
                        $rendered = $rendered -replace '\{Name\}', $styledName
                    }
                    if ($rendered -match '\{Version\}') {
                        $styledVer = Format-ThemeText -String $versionStr -Theme $themeObj -Element 'Version'
                        $rendered = $rendered -replace '\{Version\}', $styledVer
                    }
                    
                    $boxPart = $rendered.Substring(0, 24)
                    $textPart = if ($rendered.Length -gt 24) { $rendered.Substring(24) } else { "" }
                    
                    $styledBox = Format-ThemeText -String $boxPart -Theme $themeObj -Element 'Border'
                    [console]::WriteLine($styledBox + $textPart)
                }
            }
        }
        [console]::Write("`n")
    }
}
