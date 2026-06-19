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

                $paramAlias = "-$($paramInfo.param)"
                $paramType = "[$($paramInfo.type)]"
                $paramName = $paramInfo.name
                $paramDesc = $paramInfo.description
                $required = $paramInfo.required -or $false
                $inline = [bool]$paramInfo.inline

                $reqText = if ($required) { Format-ThemeText -String "(Req) " -Theme $themeObj -Element 'ParamReq' } else { "" }

                $formattedAlias = $paramAlias.PadRight($maxParamLength + $Padding)
                $formattedType = $paramType.PadRight($maxTypeLength + $Padding)

                $styledAlias = Format-ThemeText -String $formattedAlias -Theme $themeObj -Element 'ParamName'
                $styledType = Format-ThemeText -String $formattedType -Theme $themeObj -Element 'ParamType'
                $styledName = Format-ThemeText -String $paramName -Theme $themeObj -Element 'Header'

                [console]::Write("${indentString}   ${styledAlias}${styledType}${reqText}${styledName}")

                if ($inline) {
                    $styledDesc = Format-ThemeText -String "  $paramDesc" -Theme $themeObj -Element 'ParamDesc'
                    [console]::WriteLine($styledDesc)
                } else {
                    [console]::WriteLine()
                    $descIndent = $indentString + (" " * ($maxParamLength + $maxTypeLength + (2 * $Padding) + 1))
                    $styledDesc = Format-ThemeText -String "   $paramDesc" -Theme $themeObj -Element 'ParamDesc'
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

            foreach ($example in $Examples) {
                $cleanedExample = $example.Replace("//", "/")
                $styledEx = Format-ThemeText -String $cleanedExample -Theme $themeObj -Element 'Example'
                [console]::WriteLine("${indentString}   ${styledEx}`n")
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
