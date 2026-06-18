function New-AsciiColor {
    <#
    .SYNOPSIS
      Colorize a string using ANSI escape sequences.
    .DESCRIPTION
      Unified helper for colorizing strings using standard color names or 256-color palette indices.
    .PARAMETER String
      The input string to be colorized.
    .PARAMETER Color
      The foreground color name (e.g. 'green', 'red') or 256-color index (0-255).
    .PARAMETER BgColor
      The background color name or index.
    .PARAMETER Format
      Format styles: bold, dim, italic, underline, blink, reverse, hidden, strikethrough.
    #>
    [CmdletBinding()]
    [Alias('csole')]
    [OutputType([string])]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$String,

        [Parameter(Position = 1)]
        [string]$Color = 'white',

        [Parameter(Position = 2)]
        [string]$BgColor = '',

        [Parameter(Position = 3)]
        [ValidateSet('bold', 'dim', 'italic', 'underline', 'blink', 'reverse', 'hidden', 'strikethrough')]
        [string[]]$Format = @()
    )

    begin {
        $ColorMap = @{
            'black'       = 0
            'darkred'     = 1
            'darkgreen'   = 2
            'darkyellow'  = 3
            'darkblue'    = 4
            'darkmagenta' = 5
            'darkcyan'    = 6
            'gray'        = 7
            'grey'        = 7
            'darkgray'    = 8
            'darkgrey'    = 8
            'red'         = 9
            'green'       = 10
            'yellow'      = 11
            'blue'        = 12
            'magenta'     = 13
            'cyan'        = 14
            'white'       = 15
        }

        $StyleCodes = @{
            'bold'          = 1
            'dim'           = 2
            'italic'        = 3
            'underline'     = 4
            'blink'         = 5
            'reverse'       = 7
            'hidden'        = 8
            'strikethrough' = 9
        }

        $escapeSequence = [char]27
        $reset = "${escapeSequence}[0m"
    }

    process {
        if ([string]::IsNullOrEmpty($String)) {
            return $String
        }

        # Resolve Foreground Color
        $fgCode = $null
        if ($Color) {
            $colLower = $Color.ToLower()
            if ($ColorMap.ContainsKey($colLower)) {
                $fgCode = $ColorMap[$colLower]
            } elseif ($Color -match '^\d+$') {
                $fgCode = [int]$Color
            }
        }

        # Resolve Background Color
        $bgCode = $null
        if ($BgColor) {
            $bgLower = $BgColor.ToLower()
            if ($ColorMap.ContainsKey($bgLower)) {
                $bgCode = $ColorMap[$bgLower]
            } elseif ($BgColor -match '^\d+$') {
                $bgCode = [int]$BgColor
            }
        }

        # Build style prefix
        $stylePrefix = ''
        if ($Format) {
            foreach ($f in $Format) {
                $fLower = $f.ToLower()
                if ($StyleCodes.ContainsKey($fLower)) {
                    $stylePrefix += "${escapeSequence}[$($StyleCodes[$fLower])m"
                }
            }
        }

        # Build ANSI sequence
        $seq = $stylePrefix
        if ($null -ne $fgCode) {
            $seq += "${escapeSequence}[38;5;${fgCode}m"
        }
        if ($null -ne $bgCode) {
            $seq += "${escapeSequence}[48;5;${bgCode}m"
        }

        # If no colors or formatting applied, return string as-is
        if ($seq.Length -eq 0) {
            return $String
        }

        return "${seq}${String}${reset}"
    }
}
