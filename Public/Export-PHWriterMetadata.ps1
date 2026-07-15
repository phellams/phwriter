function _Resolve-SourceType {
    <#
    .SYNOPSIS
      Private helper. Walks up to 3 parent directories looking for a .psd1 manifest.
      Returns a hashtable describing whether the source file belongs to a module.
    #>
    param([string]$FilePath)

    $dir   = [System.IO.Path]::GetDirectoryName($FilePath)
    $depth = 0

    while ($dir -and $depth -lt 4) {
        $psd1Files = [System.IO.Directory]::GetFiles($dir, '*.psd1', [System.IO.SearchOption]::TopDirectoryOnly)

        if ($psd1Files.Count -gt 0) {
            $psd1 = $psd1Files[0]
            try {
                $manifest = Import-PowerShellDataFile -Path $psd1 -ErrorAction Stop
                return @{
                    IsModule      = $true
                    ModuleName    = [System.IO.Path]::GetFileNameWithoutExtension($psd1)
                    ModuleVersion = if ($manifest.ModuleVersion) { $manifest.ModuleVersion.ToString() } else { '0.0.0' }
                    ManifestPath  = $psd1
                }
            } catch {
                return @{
                    IsModule      = $true
                    ModuleName    = [System.IO.Path]::GetFileNameWithoutExtension($psd1)
                    ModuleVersion = '0.0.0'
                    ManifestPath  = $psd1
                }
            }
        }

        $parent = [System.IO.Path]::GetDirectoryName($dir)
        if ($parent -eq $dir) { break }   # filesystem root guard
        $dir = $parent
        $depth++
    }

    return @{ IsModule = $false; ModuleName = ''; ModuleVersion = ''; ManifestPath = '' }
}

function Export-PHWriterMetadata {
    <#
    .SYNOPSIS
      Extracts PHWriter help metadata automatically from a PowerShell script file using AST parsing.
    .DESCRIPTION
      Parses a .ps1 or .psm1 file using [System.Management.Automation.Language.Parser] to extract
      all function definitions, parameter blocks, types, mandatory flags, aliases, and comment-based
      help blocks. Returns a metadata object array that can be passed directly to New-PHWriter or
      serialized to a JSON file for reuse.

      Optionally restrict extraction to a single named function via -FunctionName (wildcards supported).
      Automatically detects whether the source file belongs to a PowerShell module by walking up parent
      directories for a .psd1 manifest; sets sourcetype to 'module' or 'script' accordingly.

      This is a zero-touch automation utility — no manual hashtable configuration required.
    .PARAMETER Path
      Path to the source .ps1 or .psm1 file to extract metadata from. Wildcards not supported.
    .PARAMETER FunctionName
      Optional. Extract only the named function. Supports wildcards (e.g. 'Get-*').
    .PARAMETER OutputJson
      Optional. Path to a .json file to serialize the extracted metadata into.
    .PARAMETER ModuleName
      Optional. Override the module name field in the output metadata.
    .PARAMETER Version
      Optional. Override the version field in the output metadata. Default: '1.0.0'.
    .PARAMETER Source
      Optional. Override the documentation source URL. Default: ''.
    .EXAMPLE
      Export-PHWriterMetadata -Path './Public/Get-SystemData.ps1'
    .EXAMPLE
      Export-PHWriterMetadata -Path './Public/My-Cmdlet.ps1' -FunctionName 'My-Cmdlet'
    .EXAMPLE
      Export-PHWriterMetadata -Path './Public/My-Cmdlet.ps1' -OutputJson './libs/help_metadata/my-cmdlet.json'
    .EXAMPLE
      Get-ChildItem -Path ./Public/*.ps1 | ForEach-Object {
          Export-PHWriterMetadata -Path $_.FullName -OutputJson "./libs/help_metadata/$($_.BaseName).json"
      }
    .NOTES
      Requires PowerShell 7.x or Windows PowerShell 5.1+.
      Alias: phextract
    #>
    [CmdletBinding()]
    [Alias('phextract')]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Path to the source .ps1 or .psm1 script file.")]
        [Alias('FullName')]
        [string]$Path,

        [Parameter(Mandatory = $false, HelpMessage = "Extract only the named function. Supports wildcards.")]
        [string]$FunctionName,

        [Parameter(Mandatory = $false, HelpMessage = "Output JSON file path.")]
        [string]$OutputJson,

        [Parameter(Mandatory = $false, HelpMessage = "Override module name for the metadata.")]
        [string]$ModuleName,

        [Parameter(Mandatory = $false, HelpMessage = "Override version string.")]
        [string]$Version = '1.0.0',

        [Parameter(Mandatory = $false, HelpMessage = "Override documentation source URL.")]
        [string]$Source = '',

        [Parameter(HelpMessage = "Display Help for Export-PHWriterMetadata.")]
        [switch]$Help
    )

    begin {
        # Cache ESC for any future internal logging; pure returns — no Write-Host
        $esc = [char]27
    }

    process {
        if ($Help) {
            $phextract_ParamTable = @(
                @{
                    name        = "Path"
                    param       = "p|Path"
                    type        = "String"
                    description = "Path to the source .ps1 or .psm1 script file to parse."
                    required    = $true
                    inline      = $false
                },
                @{
                    name        = "FunctionName"
                    param       = "f|FunctionName"
                    type        = "String"
                    description = "Extract only the named function. Supports wildcards."
                    required    = $false
                    inline      = $false
                },
                @{
                    name        = "OutputJson"
                    param       = "o|OutputJson"
                    type        = "String"
                    description = "Optional path to serialize the extracted metadata into a JSON file."
                    required    = $false
                    inline      = $false
                },
                @{
                    name        = "ModuleName"
                    param       = "m|ModuleName"
                    type        = "String"
                    description = "Override the module name field in the output metadata."
                    required    = $false
                    inline      = $false
                },
                @{
                    name        = "Version"
                    param       = "v|Version"
                    type        = "String"
                    description = "Override the version field in the output metadata."
                    required    = $false
                    inline      = $false
                },
                @{
                    name        = "Source"
                    param       = "s|Source"
                    type        = "String"
                    description = "Override the documentation source URL."
                    required    = $false
                    inline      = $false
                }
            )
            $phextract_commandinfo = @{
                cmdlet      = "Export-PHWriterMetadata"
                synopsis    = "Export-PHWriterMetadata -Path <String> [-FunctionName <String>] [-OutputJson <String>] [-ModuleName <String>] [-Version <String>] [-Source <String>]"
                description = "Extracts PHWriter help metadata automatically from a PowerShell script file using AST parsing."
                source      = "https://gitlab.com/phellams/phwriter"
            }
            $phextract_examples = @(
                "Export-PHWriterMetadata -Path './Public/Get-SystemData.ps1'",
                "Export-PHWriterMetadata -Path './Public/My-Cmdlet.ps1' -FunctionName 'My-Cmdlet'"
            )
            New-PHWriter -Name 'PHWRITER' -CommandInfo $phextract_commandinfo -ParamTable $phextract_ParamTable -Padding 4 -Indent 2 -Theme 'default' -Version '1.0.0' -Examples $phextract_examples
            return
        }

        if ([string]::IsNullOrEmpty($Path)) {
            throw [System.ArgumentException]::new("Path parameter is mandatory when -Help is not specified.")
        }

        # ── Validate and Load Source File ─────────────────────────────────────
        $absolutePath = [System.IO.Path]::GetFullPath($Path)

        if (-not [System.IO.File]::Exists($absolutePath)) {
            Write-Warning "Script file not found: $absolutePath"
            return $null
        }

        $extension = [System.IO.Path]::GetExtension($absolutePath).ToLower()
        if ($extension -notin @('.ps1', '.psm1')) {
            Write-Warning "Unsupported file extension: $extension. Only .ps1 and .psm1 are supported."
            return $null
        }

        # ── Module vs Script detection ────────────────────────────────────────
        $sourceType = _Resolve-SourceType -FilePath $absolutePath

        # ── AST Parse ────────────────────────────────────────────────────────
        [System.Management.Automation.Language.Token[]]$tokens      = $null
        [System.Management.Automation.Language.ParseError[]]$parseErrors = $null

        $ast = [System.Management.Automation.Language.Parser]::ParseFile(
            $absolutePath, [ref]$tokens, [ref]$parseErrors
        )

        if ($parseErrors.Count -gt 0) {
            $errList = ($parseErrors | ForEach-Object { $_.Message }) -join '; '
            Write-Warning "AST parse errors in $($absolutePath): $errList"
            return $null
        }

        # ── Discover all function definitions in the file ─────────────────────
        $functionFilter = [System.Management.Automation.Language.FunctionDefinitionAst]
        $functionDefs   = $ast.FindAll({ $args[0] -is $functionFilter }, $false)

        if (-not $functionDefs -or $functionDefs.Count -eq 0) {
            Write-Warning "No function definitions found in: $absolutePath"
            return $null
        }

        # ── Optional: filter to a specific function (wildcard-aware) ──────────
        if ($FunctionName) {
            $functionDefs = @($functionDefs | Where-Object {
                $_.Name -like $FunctionName
            })

            if ($functionDefs.Count -eq 0) {
                Write-Warning "No function matching '$FunctionName' found in: $absolutePath"
                return $null
            }
        }

        # ── Build output for each function ────────────────────────────────────
        $results = [System.Collections.Generic.List[hashtable]]::new()

        foreach ($funcDef in $functionDefs) {
            $funcName = $funcDef.Name

            # ── Resolve final module name ─────────────────────────────────────
            $resolvedModule = if ($ModuleName) {
                $ModuleName
            } elseif ($sourceType.IsModule) {
                $sourceType.ModuleName
            } else {
                [System.IO.Path]::GetFileNameWithoutExtension($absolutePath)
            }

            # ── Resolve final version ─────────────────────────────────────────
            $resolvedVersion = if ($Version -ne '1.0.0') {
                $Version   # explicit override takes priority
            } elseif ($sourceType.IsModule -and $sourceType.ModuleVersion -ne '0.0.0') {
                $sourceType.ModuleVersion
            } else {
                $Version
            }

            # ── Determine source label for display ────────────────────────────
            $sourceLabel = if ($sourceType.IsModule) { 'module' } else { 'script' }

            # ── Extract Comment-Based Help ────────────────────────────────────
            $synopsis    = ''
            $description = ''
            $exampleList = [System.Collections.Generic.List[string]]::new()
            $cbhParams   = @{}

            $helpContent = $funcDef.GetHelpContent()
            if ($helpContent) {
                $synopsis    = if ($helpContent.Synopsis)    { ($helpContent.Synopsis -replace '\s+', ' ').Trim() } else { '' }
                $description = if ($helpContent.Description) { ($helpContent.Description -replace '\s+', ' ').Trim() } else { '' }

                # Extract .PARAMETER blocks
                if ($helpContent.Parameters -is [System.Collections.Hashtable]) {
                    foreach ($key in $helpContent.Parameters.Keys) {
                        $cbhParams[$key.ToLower()] = ($helpContent.Parameters[$key] -replace '\s+', ' ').Trim()
                    }
                }

                # Extract .EXAMPLE blocks
                if ($helpContent.Examples) {
                    foreach ($ex in $helpContent.Examples) {
                        $rawCode = $ex.Code
                        if ($null -ne $rawCode) {
                            $code = $rawCode.ToString().Trim()
                            if ($code) { $exampleList.Add($code) }
                        }
                    }
                }
            }

            # Build SYNOPSIS fallback from function name
            if (-not $synopsis) {
                $synopsis = "$funcName [<Parameters>]"
            }

            # ── Build SYNTAX string ───────────────────────────────────────────
            $syntaxTokens = [System.Collections.Generic.List[string]]::new()
            $syntaxTokens.Add($funcName)

            # ── Parse Parameter Block ─────────────────────────────────────────
            $paramTable = [System.Collections.Generic.List[hashtable]]::new()

            $paramBlock = $funcDef.Body.ParamBlock
            if ($paramBlock -and $paramBlock.Parameters.Count -gt 0) {
                # Pre-calculate all function parameter names and explicit aliases for collision checking
                $functionParamNames = [System.Collections.Generic.List[string]]::new()
                $explicitAliases = [System.Collections.Generic.List[string]]::new()
                foreach ($pAst in $paramBlock.Parameters) {
                    $pName = $pAst.Name.VariablePath.UserPath
                    $functionParamNames.Add($pName)
                    foreach ($attr in $pAst.Attributes) {
                        if ($attr.TypeName.Name -in @('Alias', 'AliasAttribute')) {
                            foreach ($posArg in $attr.PositionalArguments) {
                                if ($posArg -is [System.Management.Automation.Language.StringConstantExpressionAst]) {
                                    $explicitAliases.Add($posArg.Value)
                                }
                            }
                        }
                    }
                }

                # Keep track of smart aliases generated in this function
                $generatedSmartAliases = [System.Collections.Generic.List[string]]::new()

                foreach ($paramAst in $paramBlock.Parameters) {
                    $paramVarName = $paramAst.Name.VariablePath.UserPath

                    # Resolve static type name
                    $typeName = 'Object'
                    if ($paramAst.StaticType -and $paramAst.StaticType.Name) {
                        $typeName = $paramAst.StaticType.Name
                    }

                    $isMandatory = $false
                    $aliasList   = [System.Collections.Generic.List[string]]::new()
                    $helpMessage = ''

                    # ── Walk all attributes on this parameter ─────────────────
                    foreach ($attr in $paramAst.Attributes) {
                        $attrName = $attr.TypeName.Name

                        if ($attrName -eq 'Parameter') {
                            foreach ($namedArg in $attr.NamedArguments) {
                                switch ($namedArg.ArgumentName.ToLower()) {
                                    'mandatory'   {
                                        $val = $namedArg.Argument
                                        if ($val -is [System.Management.Automation.Language.VariableExpressionAst]) {
                                            $isMandatory = ($val.VariablePath.UserPath -eq 'true')
                                        } elseif ($val -is [System.Management.Automation.Language.ConstantExpressionAst]) {
                                            $isMandatory = [bool]$val.Value
                                        }
                                    }
                                    'helpmessage' {
                                        $val = $namedArg.Argument
                                        if ($val -is [System.Management.Automation.Language.StringConstantExpressionAst]) {
                                            $helpMessage = $val.Value
                                        }
                                    }
                                }
                            }
                        }

                        if ($attrName -in @('Alias', 'AliasAttribute')) {
                            foreach ($posArg in $attr.PositionalArguments) {
                                if ($posArg -is [System.Management.Automation.Language.StringConstantExpressionAst]) {
                                    $aliasList.Add($posArg.Value)
                                }
                            }
                        }
                    }

                    # ── Generate Smart Alias ──────────────────────────────────
                    $blockedForParam = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
                    
                    $commonParams = @(
                        'Verbose', 'Debug', 'ErrorAction', 'WarningAction', 'InformationAction',
                        'ErrorVariable', 'WarningVariable', 'InformationVariable', 'OutVariable',
                        'OutBuffer', 'PipelineVariable', 'WhatIf', 'Confirm', 'UseTransaction'
                    )
                    $commonAliases = @(
                        'vb', 'db', 'ea', 'wa', 'infa', 'ev', 'wv', 'infv', 'ov', 'ob', 'pv'
                    )
                    foreach ($cp in $commonParams) { $blockedForParam.Add($cp) | Out-Null }
                    foreach ($ca in $commonAliases) { $blockedForParam.Add($ca) | Out-Null }

                    foreach ($fp in $functionParamNames) {
                        if ($fp -ne $paramVarName) { $blockedForParam.Add($fp) | Out-Null }
                    }

                    foreach ($ea in $explicitAliases) {
                        if ($ea -notin $aliasList) { $blockedForParam.Add($ea) | Out-Null }
                    }

                    foreach ($gsa in $generatedSmartAliases) {
                        $blockedForParam.Add($gsa) | Out-Null
                    }

                    $smartAlias = $null
                    for ($len = 1; $len -le $paramVarName.Length; $len++) {
                        $candidate = $paramVarName.Substring(0, $len)
                        if (-not $blockedForParam.Contains($candidate)) {
                            $smartAlias = $candidate
                            break
                        }
                    }

                    if ($smartAlias -and $smartAlias -ne $paramVarName -and $smartAlias -notin $aliasList) {
                        $aliasList.Insert(0, $smartAlias)
                        $generatedSmartAliases.Add($smartAlias) | Out-Null
                    }

                    # ── Build param field string ──────────────────────────────
                    # Format: "a|AliasB|ParamName" — first alias(es) then full name
                    $paramFieldParts = [System.Collections.Generic.List[string]]::new()
                    foreach ($a in $aliasList) { $paramFieldParts.Add($a) }
                    $paramFieldParts.Add($paramVarName)
                    $paramField = $paramFieldParts -join '|'

                    # ── Resolve description (CBH takes precedence over HelpMessage) ─
                    $descKey = $paramVarName.ToLower()
                    $desc = if ($cbhParams.ContainsKey($descKey)) {
                        $cbhParams[$descKey]
                    } elseif ($helpMessage) {
                        $helpMessage
                    } else {
                        "Parameter $paramVarName."
                    }

                    # ── Build syntax fragment ─────────────────────────────────
                    if ($isMandatory) {
                        $syntaxTokens.Add("-$paramVarName <$typeName>")
                    } else {
                        $syntaxTokens.Add("[-$paramVarName <$typeName>]")
                    }

                    $paramTable.Add(@{
                        name        = $paramVarName
                        param       = $paramField
                        type        = $typeName
                        required    = $isMandatory
                        description = $desc
                        inline      = $false
                    })
                }
            }

            # ── Assemble final syntax line ────────────────────────────────────
            $syntaxLine = $syntaxTokens -join ' '

            $metadata = @{
                name        = $resolvedModule
                version     = $resolvedVersion
                sourcetype  = $sourceLabel        # 'module' or 'script'
                commandinfo = @{
                    cmdlet      = $funcName
                    synopsis    = $syntaxLine
                    description = $description
                    source      = $Source
                }
                paramtable  = $paramTable.ToArray()
                examples    = $exampleList.ToArray()
            }

            $results.Add($metadata)
        }

        # ── Optional JSON serialization ───────────────────────────────────────
        if ($OutputJson -and $results.Count -gt 0) {
            $outputAbsPath = [System.IO.Path]::GetFullPath($OutputJson)
            $outputDir     = [System.IO.Path]::GetDirectoryName($outputAbsPath)

            if (-not [System.IO.Directory]::Exists($outputDir)) {
                [System.IO.Directory]::CreateDirectory($outputDir) | Out-Null
            }

            # If multiple functions found, serialize as array; else single object
            $toSerialize = if ($results.Count -eq 1) { $results[0] } else { $results.ToArray() }
            $json = $toSerialize | ConvertTo-Json -Depth 10 -Compress:$false
            [System.IO.File]::WriteAllText($outputAbsPath, $json, [System.Text.UTF8Encoding]::new($false))
        }

        # ── Return all found metadata objects ─────────────────────────────────
        if ($results.Count -eq 1) {
            return $results[0]
        }
        return $results.ToArray()
    }
}
