function New-PHWriter {
    <#
    .SYNOPSIS
      Generates formatted, colored help text for PowerShell cmdlets and router functions.
    .DESCRIPTION
      Outputs man-page style documentation with customizable layout, alignment, and 10 default themes.
      Supports documenting both parameters and router subcommands.
    .PARAMETER JsonFile
      JSON file containing help configuration parameters to load.
    .PARAMETER Name
      The name of the module/tool. Default is 'PHW'.
    .PARAMETER CommandInfo
      A hashtable or custom object containing command metadata: cmdlet, synopsis, description, source.
    .PARAMETER ParamTable
      An array of hashtables defining parameters: name, param, type, required, description, inline.
    .PARAMETER Subcommands
      An array of hashtables defining router subcommands: name, syntax, description.
    .PARAMETER Examples
      An array of usage example strings.
    .PARAMETER Version
      The module version to display. Default is '1.0.0'.
    .PARAMETER Padding
      Spaces of padding between columns. Default is 3. Increase for a more airy look, decrease for compact output.
    .PARAMETER Indent
      Spaces of left indentation for each line. Default is 1.
    .PARAMETER LineSpacing
      Number of blank lines between each parameter row. Default is 1. Set 0 for compact mode.
    .PARAMETER SourceType
      Header label identifying the documentation target type: 'module', 'script', 'tool', or 'plugin'. Default is 'module'.
      Label type for the header line: 'module', 'script', 'tool', or 'plugin'. Default: 'module'.
    .PARAMETER Theme
      The name of a default theme ('default', 'matrix', 'cyberpunk', etc.) or a custom theme object.
    .PARAMETER Layout
      The ASCII banner layout: 'Box', 'Classic', 'Minimal', 'Man', 'Terminal', 'Typewriter'. Default is 'Box'.
    .PARAMETER CustomLogo
      An optional custom ASCII logo string.
    .PARAMETER Help
      Switch to display help information for New-PHWriter itself.
    #>
    [CmdletBinding()]
    [OutputType('void')]
    param(
        [Parameter(Mandatory = $false, HelpMessage = "Json File to import help data from.")]
        [string]$JsonFile,

        [Parameter(HelpMessage = "Sets the Name of the module to display.")]
        [string]$Name,

        [Parameter(Mandatory = $false, HelpMessage = "Command details: cmdlet, synopsis, description, source.")]
        [object]$CommandInfo,

        [Parameter(Mandatory = $false, HelpMessage = "An array of hashtables defining parameters.")]
        [array]$ParamTable,

        [Parameter(Mandatory = $false, HelpMessage = "An array of hashtables defining router subcommands.")]
        [array]$Subcommands,

        [Parameter(Mandatory = $false, HelpMessage = "Example command calls.")]
        [string[]]$Examples,

        [Parameter(Mandatory = $false, HelpMessage = "Version of the command to display.")]
        [string]$Version,

        [Parameter(HelpMessage = "Number of spaces for padding between columns. Default: 3.")]
        [int]$Padding = 3,

        [Parameter(HelpMessage = "Number of spaces for left indentation of each line. Default: 1.")]
        [int]$Indent = 1,

        [Parameter(HelpMessage = "Blank lines between parameter rows. 0=compact, 1=default, 2=spacious.")]
        [ValidateRange(0, 4)]
        [int]$LineSpacing = 1,

        [Parameter(HelpMessage = "Header label type: module, script, tool, or plugin.")]
        [ValidateSet('module', 'script', 'tool', 'plugin')]
        [string]$SourceType = 'module',

        [Parameter(HelpMessage = "Theme name or custom theme object.")]
        $Theme = 'default',

        [Parameter(HelpMessage = "The ASCII banner layout style.")]
        [ValidateSet('Box', 'Classic', 'Minimal', 'Man', 'Terminal', 'Typewriter')]
        [string]$Layout = 'Box',

        [Parameter(HelpMessage = "Custom logo banner string.")]
        [string]$CustomLogo = $null,

        [Parameter(HelpMessage = "Display Help for New-PHWriter.")]
        [switch]$Help
    )

    process {
        # Internal Help parameters for New-PHWriter itself
        if ($Help) {
            $phwriter_ParamTable = @(
                @{
                    name        = "JsonFile"
                    param       = "j|JsonFile"
                    type        = "String"
                    description = "JSON file containing help configuration parameters to load."
                    required    = $false
                    inline      = $false
                },
                @{
                    name        = "Name"
                    param       = "n|Name"
                    type        = "String"
                    description = "The name of the module, script, or tool to display."
                    required    = $false
                    inline      = $false
                },
                @{
                    name        = "CommandInfo"
                    param       = "c|CommandInfo"
                    type        = "Hashtable"
                    description = "Command details: cmdlet, synopsis, description, source."
                    required    = $false
                    inline      = $false
                },
                @{
                    name        = "ParamTable"
                    param       = "p|ParamTable"
                    type        = "Hashtable[]"
                    description = "Array of parameter hashtables: name, param, type, required, description, inline."
                    required    = $false
                    inline      = $false
                },
                @{
                    name        = "Subcommands"
                    param       = "sub|Subcommands"
                    type        = "Hashtable[]"
                    description = "Array of router subcommand hashtables: name, syntax, description."
                    required    = $false
                    inline      = $false
                },
                @{
                    name        = "Version"
                    param       = "v|Version"
                    type        = "String"
                    description = "Version string to display in the header. Default: '1.0.0'."
                    required    = $false
                    inline      = $false
                },
                @{
                    name        = "Padding"
                    param       = "pad|Padding"
                    type        = "Int"
                    description = "Column padding in spaces. Default: 3. Lower for compact, higher for airy layout."
                    required    = $false
                    inline      = $false
                },
                @{
                    name        = "Indent"
                    param       = "i|Indent"
                    type        = "Int"
                    description = "Left indentation in spaces. Default: 1."
                    required    = $false
                    inline      = $false
                },
                @{
                    name        = "LineSpacing"
                    param       = "ls|LineSpacing"
                    type        = "Int"
                    description = "Blank lines between parameter rows. 0=compact, 1=default, 2=spacious."
                    required    = $false
                    inline      = $false
                },
                @{
                    name        = "SourceType"
                    param       = "st|SourceType"
                    type        = "String"
                    description = "Label type for the header line: 'module', 'script', 'tool', or 'plugin'. Default: 'module'."
                    required    = $false
                    inline      = $false
                },
                @{
                    name        = "Theme"
                    param       = "t|Theme"
                    type        = "String|Hashtable"
                    description = "Theme name (20 built-in) or a custom theme hashtable."
                    required    = $false
                    inline      = $false
                },
                @{
                    name        = "Layout"
                    param       = "l|Layout"
                    type        = "String"
                    description = "Banner layout: 'Box', 'Classic', 'Minimal', 'Man', 'Terminal', 'Typewriter'."
                    required    = $false
                    inline      = $false
                }
            )
            $phwriter_commandinfo = @{
                cmdlet      = "New-PHWriter"
                synopsis    = "New-PHWriter [-Name <String>] [-CommandInfo <Hashtable>] [-ParamTable <Hashtable[]>] [-Theme <String>] [-Layout <String>] [-LineSpacing <Int>] [-SourceType <String>]"
                description = "Generates beautifully formatted, colorized help text for cmdlets and router functions. Supports 20 built-in themes, 6 layouts, compact/spacious line spacing, and dynamic source-type header labeling."
                source      = "https://gitlab.com/phellams/phwriter/blob/main/README.md"
            }
            $phwriter_examples = @(
                'New-PHWriter -Help',
                'New-PHWriter -Name "PHWriter" -Theme "matrix" -Layout "Terminal" -CommandInfo $info -ParamTable $params',
                'New-PHWriter -Name "git" -Subcommands $gitSubcommands -Theme "cyberpunk"'
            )

            New-PHWriter -Name 'PHWRITER' -CommandInfo $phwriter_commandinfo -ParamTable $phwriter_ParamTable -Padding 4 -Indent 2 -Theme $Theme -Layout $Layout -Version '1.0.0' -Examples $phwriter_examples
            return
        }

        # Load JSON data if a JsonFile is provided
        if ($JsonFile) {
            $jsonFile_FullPath = Get-ChildItem -Path $JsonFile | Select-Object -First 1
            if ($null -ne $jsonFile_FullPath) {
                try {
                    $jsonData = ConvertFrom-Json $([System.IO.File]::ReadAllText($jsonFile_FullPath.FullName)) -AsHashtable
                    # Override variables if they exist in JSON
                    if ($jsonData.name) { $Name = $jsonData.name }
                    if ($jsonData.commandinfo) { $CommandInfo = $jsonData.commandinfo }
                    if ($jsonData.paramtable) { $ParamTable = $jsonData.paramtable }
                    if ($jsonData.subcommands) { $Subcommands = $jsonData.subcommands }
                    if ($jsonData.examples) { $Examples = $jsonData.examples }
                    if ($jsonData.version) { $Version = $jsonData.version }
                    if ($jsonData.padding) { $Padding = $jsonData.padding }
                    if ($jsonData.indent) { $Indent = $jsonData.indent }
                    if ($jsonData.theme) { $Theme = $jsonData.theme }
                    if ($jsonData.layout) { $Layout = $jsonData.layout }
                    if ($jsonData.customlogo) { $CustomLogo = $jsonData.customlogo }
                } catch {
                    Write-Warning "Failed to parse JSON file: $_"
                    return
                }
            } else {
                Write-Warning "JSON file not found: $JsonFile"
                return
            }
        }

        # Fallbacks
        if (!$Name) { $Name = 'PHW' }
        if (!$Version) { $Version = '1.0.0' }
        $indentString  = " " * $Indent
        $blankLine     = "`n" * $LineSpacing  # blank lines between param rows

        # Resolve Theme
        $themeObj = $null
        if ($Theme -is [hashtable]) {
            $themeObj = $Theme
        } else {
            $themeObj = Get-PHTheme -Name $Theme
        }

        # Output Logo
        Write-PHAsciiLogo -Name $Name -Version $Version -Theme $themeObj -Layout $Layout -CustomLogo $CustomLogo

        # Sections config
        $sectionChar = if ($themeObj.ContainsKey('SectionChar')) { $themeObj['SectionChar'] } else { '◉' }
        $headerChar = if ($themeObj.ContainsKey('HeaderChar')) { $themeObj['HeaderChar'] } else { '▶' }
        
        $styledSecChar = if ($sectionChar) { Format-ThemeText -String "$sectionChar " -Theme $themeObj -Element 'Accent' } else { "" }
        $styledHeadChar = if ($headerChar) { Format-ThemeText -String " $headerChar " -Theme $themeObj -Element 'Accent' } else { " " }

        # Display Version / Metadata Header
        # Format: <SourceType> <Name> ▶ CMDLET <Cmdlet> ▶ VERSION <Version>
        $typeLabel  = $SourceType.ToUpper()
        $headerParts = @()
        $headerParts += "$(Format-ThemeText -String $typeLabel -Theme $themeObj -Element 'Accent') $(Format-ThemeText -String $Name -Theme $themeObj -Element 'Header')"
        if ($CommandInfo.cmdlet) {
            $headerParts += "$(Format-ThemeText -String 'CMDLET' -Theme $themeObj -Element 'Accent') $(Format-ThemeText -String ($CommandInfo.cmdlet) -Theme $themeObj -Element 'Header')"
        }
        $headerParts += "$(Format-ThemeText -String 'VERSION' -Theme $themeObj -Element 'Accent') $(Format-ThemeText -String "v$Version" -Theme $themeObj -Element 'Version')"

        [console]::WriteLine($indentString + ($headerParts -join $styledHeadChar))
        [console]::WriteLine("`n")

        # 1. SYNTAX Section
        if ($CommandInfo.synopsis) {
            $syntaxTitle = Format-ThemeText -String "SYNTAX" -Theme $themeObj -Element 'Accent'
            [console]::WriteLine("${indentString}${styledSecChar}${syntaxTitle}`n")
            $syntaxText = Format-ThemeText -String ($CommandInfo.synopsis) -Theme $themeObj -Element 'Syntax'
            [console]::WriteLine($(New-Paragraph -position 100 -indent ($Indent + 2) -string $syntaxText))
            [console]::WriteLine("`n")
        }

        # 2. DESCRIPTION Section
        if ($CommandInfo.description) {
            $descTitle = Format-ThemeText -String "DESCRIPTION" -Theme $themeObj -Element 'Accent'
            [console]::WriteLine("${indentString}${styledSecChar}${descTitle}`n")
            $descText = Format-ThemeText -String ($CommandInfo.description) -Theme $themeObj -Element 'Description'
            [console]::WriteLine($(New-Paragraph -position 100 -indent ($Indent + 2) -string $descText))
            [console]::WriteLine("`n")
        }

        # 3. SUBCOMMANDS Section (For Router functions)
        if ($Subcommands -and $Subcommands.Count -gt 0) {
            $subTitle = Format-ThemeText -String "SUBCOMMANDS" -Theme $themeObj -Element 'Accent'
            [console]::WriteLine("${indentString}${styledSecChar}${subTitle}`n")

            $maxSubLength = 0
            foreach ($sub in $Subcommands) {
                if ($sub.name.Length -gt $maxSubLength) {
                    $maxSubLength = $sub.name.Length
                }
            }

            foreach ($sub in $Subcommands) {
                $subNameFormatted = $sub.name.PadRight($maxSubLength + $Padding)
                $styledSubName = Format-ThemeText -String $subNameFormatted -Theme $themeObj -Element 'ParamName'
                $styledSubSyntax = Format-ThemeText -String $sub.syntax -Theme $themeObj -Element 'ParamType'
                $styledSubDesc = Format-ThemeText -String $sub.description -Theme $themeObj -Element 'ParamDesc'

                [console]::WriteLine("${indentString}   ${styledSubName}${styledSubSyntax}")
                $descIndent = $indentString + (" " * ($maxSubLength + $Padding + 4))
                [console]::WriteLine("${descIndent}${styledSubDesc}")
                [console]::WriteLine("`n")
            }
        }

        # 4. PARAMETERS Section
        if ($ParamTable -and $ParamTable.Count -gt 0) {
            $paramTitle = Format-ThemeText -String "PARAMETERS" -Theme $themeObj -Element 'Accent'
            [console]::WriteLine("${indentString}${styledSecChar}${paramTitle}`n")

            $maxParamLength = 0
            $maxTypeLength = 0

            foreach ($paramInfo in $ParamTable) {
                if (-not ($paramInfo.name -and $paramInfo.param -and $paramInfo.type -and $paramInfo.description)) {
                    continue
                }
                $paramField = "-$($paramInfo.param)"
                if ($paramField.Length -gt $maxParamLength) {
                    $maxParamLength = $paramField.Length
                }
                $typeField = "[$($paramInfo.type)]"
                if ($typeField.Length -gt $maxTypeLength) {
                    $maxTypeLength = $typeField.Length
                }
            }

            foreach ($paramInfo in $ParamTable) {
                if (-not ($paramInfo.name -and $paramInfo.param -and $paramInfo.type -and $paramInfo.description)) {
                    continue
                }

                $paramType = "[$($paramInfo.type)]"
                $paramName = $paramInfo.name
                $paramDesc = $paramInfo.description
                $required = $paramInfo.required -or $false
                $inline = [bool]$paramInfo.inline

                # Swap (req) to the end of param name, styled.
                $reqText = if ($required) { " " + (Format-ThemeText -String "(Req)" -Theme $themeObj -Element 'ParamReq') } else { "" }

                # Format alias with pipe coloring if present
                if ($paramInfo.param -like '*|*') {
                    $parts = $paramInfo.param -split '\|', 2
                    $shorthandRaw = "-$($parts[0])"
                    $pipeRaw = "|"
                    $targetLongNameLength = ($maxParamLength + $Padding) - ($shorthandRaw.Length + 1)
                    $longNameRaw = $parts[1].PadRight($targetLongNameLength)

                    $styledShorthand = Format-ThemeText -String $shorthandRaw -Theme $themeObj -Element 'ParamName'
                    $styledPipe = Format-ThemeText -String $pipeRaw -Theme $themeObj -Element 'Border'
                    $styledLongName = Format-ThemeText -String $longNameRaw -Theme $themeObj -Element 'ParamName'
                    $styledAlias = $styledShorthand + $styledPipe + $styledLongName
                } else {
                    $paramAlias = "-$($paramInfo.param)"
                    $formattedAlias = $paramAlias.PadRight($maxParamLength + $Padding)
                    $styledAlias = Format-ThemeText -String $formattedAlias -Theme $themeObj -Element 'ParamName'
                }

                $formattedType = $paramType.PadRight($maxTypeLength + $Padding)
                $styledType = Format-ThemeText -String $formattedType -Theme $themeObj -Element 'ParamType'
                $styledName = Format-ThemeText -String $paramName -Theme $themeObj -Element 'Header'

                [console]::Write("${indentString}   ${styledAlias}${styledType}${styledName}${reqText}")

                # Format single quotes inside $paramDesc
                $descParts = $paramDesc -split "'"
                $resultParts = [System.Collections.Generic.List[string]]::new()
                for ($i = 0; $i -lt $descParts.Count; $i++) {
                    if ($i % 2 -eq 1) {
                        $quotedText = "'$($descParts[$i])'"
                        $colorValue = if ($themeObj.ContainsKey('AccentColor')) { $themeObj['AccentColor'] } else { 'cyan' }
                        $styledQuoted = New-AsciiColor -String $quotedText -Color $colorValue -Format @('bold', 'italic')
                        $resultParts.Add($styledQuoted)
                    } else {
                        if ($descParts[$i].Length -gt 0) {
                            $styledOutside = Format-ThemeText -String $descParts[$i] -Theme $themeObj -Element 'ParamDesc'
                            $resultParts.Add($styledOutside)
                        }
                    }
                }
                $styledDescText = $resultParts -join ""

                # Determine if description should be inline (only indent if too long)
                $startLength = $Indent + 3 + ($maxParamLength + $Padding) + ($maxTypeLength + $Padding) + $paramName.Length + ($(if ($required) { 6 } else { 0 }))
                $shouldInline = $inline -or (($startLength + 2 + $paramDesc.Length) -le 80)

                if ($shouldInline) {
                    $styledDesc = "  " + $styledDescText
                    [console]::WriteLine($styledDesc)
                } else {
                    [console]::WriteLine()
                    $descIndent = $indentString + (" " * ($maxParamLength + $maxTypeLength + (2 * $Padding) + 1))
                    $styledDesc = "   " + $styledDescText
                    [console]::WriteLine("${descIndent}${styledDesc}")
                }
                # Emit $LineSpacing blank lines between param entries
                for ($ls = 0; $ls -lt $LineSpacing; $ls++) { [console]::WriteLine() }
            }
        }

        # 5. EXAMPLES Section
        if ($Examples -and $Examples.Count -gt 0) {
            $exTitle = Format-ThemeText -String "EXAMPLES" -Theme $themeObj -Element 'Accent'
            [console]::WriteLine("${indentString}${styledSecChar}${exTitle}`n")

            $getHighlightedExample = {
                param(
                    [string]$ExText,
                    $Theme
                )
                $cmdletFormat = if ($Theme.AccentFormat) { @($Theme.AccentFormat -split ',') | Where-Object { $_ -and $_ -ne 'none' } } else { @() }
                $cParams = @{ String = "X"; Color = $Theme.AccentColor }
                $cFormatList = [System.Collections.Generic.List[string]]::new()
                foreach ($f in $cmdletFormat) { [void]$cFormatList.Add($f) }
                if (-not $cFormatList.Contains('bold')) { [void]$cFormatList.Add('bold') }
                $cParams['Format'] = $cFormatList.ToArray()
                $cmdletColor = New-AsciiColor @cParams
                $cmdletSeq = if ($cmdletColor.EndsWith("[0m")) { $cmdletColor.Substring(0, $cmdletColor.Length - 5) } else { "" }

                $pFormat = if ($Theme.ParamNameFormat) { @($Theme.ParamNameFormat -split ',') | Where-Object { $_ -and $_ -ne 'none' } } else { @() }
                $pParams = @{ String = "X"; Color = $Theme.ParamNameFg }
                if ($pFormat -and $pFormat.Count -gt 0) { $pParams['Format'] = $pFormat }
                $pEsc = New-AsciiColor @pParams
                $paramSeq = if ($pEsc.EndsWith("[0m")) { $pEsc.Substring(0, $pEsc.Length - 5) } else { "" }

                $sFormat = if ($Theme.ParamTypeFormat) { @($Theme.ParamTypeFormat -split ',') | Where-Object { $_ -and $_ -ne 'none' } } else { @() }
                $sParams = @{ String = "X"; Color = $Theme.ParamTypeFg }
                if ($sFormat -and $sFormat.Count -gt 0) { $sParams['Format'] = $sFormat }
                $sEsc = New-AsciiColor @sParams
                $stringSeq = if ($sEsc.EndsWith("[0m")) { $sEsc.Substring(0, $sEsc.Length - 5) } else { "" }

                $reset = [char]27 + "[0m"

                $pattern = '(?<string>\''[^\'']*\''|"[^"]*")|(?<param>-\w+(\|\w+)?)|(?<cmdlet>\b[A-Za-z]+-[A-Za-z]+\w*\b)|(?<word>\S+)|(?<space>\s+)'
                $matches = [System.Text.RegularExpressions.Regex]::Matches($ExText, $pattern)
                $sb = [System.Text.StringBuilder]::new()
                $seenFirstWord = $false

                foreach ($m in $matches) {
                    if ($m.Groups['string'].Success) {
                        [void]$sb.Append("${stringSeq}$($m.Value)${reset}")
                    } elseif ($m.Groups['param'].Success) {
                        if ($m.Value -like '*|*') {
                            $parts = $m.Value -split '\|', 2
                            $pipeEsc = New-AsciiColor -String "|" -Color $Theme.BorderColor
                            [void]$sb.Append("${paramSeq}$($parts[0])${reset}${pipeEsc}${paramSeq}$($parts[1])${reset}")
                        } else {
                            [void]$sb.Append("${paramSeq}$($m.Value)${reset}")
                        }
                    } elseif ($m.Groups['cmdlet'].Success) {
                        $seenFirstWord = $true
                        [void]$sb.Append("${cmdletSeq}$($m.Value)${reset}")
                    } elseif ($m.Groups['word'].Success) {
                        if (-not $seenFirstWord) {
                            $seenFirstWord = $true
                            [void]$sb.Append("${cmdletSeq}$($m.Value)${reset}")
                        } else {
                            [void]$sb.Append($m.Value)
                        }
                    } else {
                        [void]$sb.Append($m.Value)
                    }
                }
                return $sb.ToString()
            }

            foreach ($example in $Examples) {
                $cleanedExample = $example.Replace("//", "/")
                $styledEx = & $getHighlightedExample $cleanedExample $themeObj
                [console]::WriteLine("${indentString}    ${styledEx}`n")
            }
        }

        # 6. Docs / Source Link
        if ($CommandInfo.source) {
            $docsTitle = Format-ThemeText -String "★ Docs:" -Theme $themeObj -Element 'Accent'
            $docsLink = Format-ThemeText -String ($CommandInfo.source) -Theme $themeObj -Element 'Docs'
            [console]::WriteLine("${indentString} ${docsTitle} ${docsLink} for more info")
            [console]::WriteLine()
        }
    }
}
