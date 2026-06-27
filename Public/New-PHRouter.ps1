function New-PHRouter {
    <#
    .SYNOPSIS
      Scaffolds and dispatches a standardized subcommand router for PowerShell CLI modules.
    .DESCRIPTION
      New-PHRouter provides a zero-boilerplate router framework. Pass a route map hashtable
      (subcommand name → scriptblock or function name), the raw argument array, and optional
      PHWriter metadata for auto-registration of argument completers.

      Features:
        • Tab-completion auto-registration via Register-ArgumentCompleter
        • Unknown subcommand detection with "Did you mean?" fuzzy matching
        • Automatic '--help' / '-h' flag passthrough to the routed function
        • Optional 'default' route (called when no subcommand is given)
        • Zero external dependencies — pure .NET + PowerShell

    .PARAMETER Routes
      A hashtable mapping subcommand name strings to either:
        - A [scriptblock] to invoke directly
        - A [string] naming a function that exists in scope
      A special key 'default' is called when no subcommand is matched.

    .PARAMETER ArgumentList
      The raw argument array to dispatch. Typically $args or $PSBoundParameters values.
      The first element is the subcommand key.

    .PARAMETER ModuleName
      The name of the module/router. Used in error/help output. Default: 'PHRouter'.

    .PARAMETER RegisterCompleter
      When specified, auto-registers a tab-completion ArgumentCompleter for the ModuleName
      so that subcommand keys are offered as completions.

    .PARAMETER Metadata
      Optional PHWriter metadata hashtable (from Export-PHWriterMetadata or New-PHWriter's
      input format). If provided, the route map is validated against metadata and discrepancies
      are reported as warnings.

    .EXAMPLE
      # Basic router in a CLI entrypoint function
      function Invoke-MyCLI {
          param([Parameter(ValueFromRemainingArguments)][string[]]$args)
          $routes = @{
              'build'   = { param($rest) Invoke-Build @rest }
              'test'    = 'Invoke-Tests'
              'version' = { Write-Host "v1.0.0" }
              'default' = { Write-Host "Run: mycli <build|test|version>" }
          }
          New-PHRouter -Routes $routes -ArgumentList $args -ModuleName 'mycli' -RegisterCompleter
      }

    .EXAMPLE
      # With PHWriter metadata auto-validation
      $meta = Export-PHWriterMetadata -Path './Public/Invoke-MyCLI.ps1'
      New-PHRouter -Routes $routes -ArgumentList $args -ModuleName 'mycli' -Metadata $meta

    .NOTES
      Alias: phroute
    #>
    [CmdletBinding()]
    [Alias('phroute')]
    param(
        [Parameter(Mandatory = $false, Position = 0, HelpMessage = "Subcommand route map.")]
        [hashtable]$Routes,

        [Parameter(Mandatory = $false, Position = 1, ValueFromRemainingArguments = $false, HelpMessage = "Raw argument array.")]
        [string[]]$ArgumentList = @(),

        [Parameter(Mandatory = $false, HelpMessage = "Module/CLI name for messaging.")]
        [string]$ModuleName = 'PHRouter',

        [Parameter(Mandatory = $false, HelpMessage = "Auto-register tab-completion for subcommand keys.")]
        [switch]$RegisterCompleter,

        [Parameter(Mandatory = $false, HelpMessage = "PHWriter metadata for validation.")]
        [object]$Metadata,

        [Parameter(Mandatory = $false, HelpMessage = "Theme name or custom theme object.")]
        [object]$Theme = 'default',

        [Parameter(HelpMessage = "Display Help for New-PHRouter.")]
        [switch]$Help
    )

    # ── Help support ──────────────────────────────────────────────────────────
    if ($Help) {
        $phrouter_ParamTable = @(
            @{
                name        = "Routes"
                param       = "r|Routes"
                type        = "Hashtable"
                description = "Subcommand route map (subcommand -> scriptblock/string)."
                required    = $true
                inline      = $false
            },
            @{
                name        = "ArgumentList"
                param       = "args|ArgumentList"
                type        = "String[]"
                description = "Raw argument array to dispatch."
                required    = $false
                inline      = $false
            },
            @{
                name        = "ModuleName"
                param       = "m|ModuleName"
                type        = "String"
                description = "Module/CLI name for messaging. Default: 'PHRouter'."
                required    = $false
                inline      = $false
            },
            @{
                name        = "RegisterCompleter"
                param       = "rc|RegisterCompleter"
                type        = "Switch"
                description = "Auto-register tab-completion for subcommand keys."
                required    = $false
                inline      = $true
            },
            @{
                name        = "Metadata"
                param       = "meta|Metadata"
                type        = "Object"
                description = "PHWriter metadata for route validation."
                required    = $false
                inline      = $false
            },
            @{
                name        = "Theme"
                param       = "th|Theme"
                type        = "String|Hashtable"
                description = "Theme name or custom theme object."
                required    = $false
                inline      = $false
            }
        )
        $phrouter_commandinfo = @{
            cmdlet      = "New-PHRouter"
            synopsis    = "New-PHRouter -Routes <Hashtable> [-ArgumentList <String[]>] [-ModuleName <String>] [-RegisterCompleter] [-Metadata <Object>] [-Theme <Object>]"
            description = "Scaffolds and dispatches a standardized subcommand router for PowerShell CLI modules."
            source      = "https://gitlab.com/phellams/phwriter"
        }
        $phrouter_examples = @(
            "New-PHRouter -Routes \$routes -ArgumentList \$args -ModuleName 'mycli' -RegisterCompleter",
            "New-PHRouter -Routes \$routes -ArgumentList \$args -Theme 'steel-plate'"
        )
        New-PHWriter -Name 'PHWRITER' -CommandInfo $phrouter_commandinfo -ParamTable $phrouter_ParamTable -Padding 4 -Indent 2 -Theme $Theme -Version '1.0.0' -Examples $phrouter_examples
        return
    }

    if ($null -eq $Routes) {
        throw [System.ArgumentException]::new("Routes parameter is mandatory when -Help is not specified.")
    }

    # ── Auto-register tab completer ───────────────────────────────────────────
    if ($RegisterCompleter) {
        $routeKeys = @($Routes.Keys | Where-Object { $_ -ne 'default' } | Sort-Object)
        $scriptBlock = [scriptblock]::Create(
            'param($wordToComplete, $commandAst, $cursorPosition);' +
            '$keys = @(' + (($routeKeys | ForEach-Object { "'$_'" }) -join ',') + ');' +
            '$keys | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object {' +
            '[System.Management.Automation.CompletionResult]::new($_, $_, "ParameterValue", $_) }'
        )
        Register-ArgumentCompleter -Native -ScriptBlock $scriptBlock -CommandName $ModuleName -ErrorAction SilentlyContinue
    }

    # ── Validate routes against metadata (if provided) ────────────────────────
    if ($Metadata) {
        $metaSubcmds = @()
        if ($Metadata.subcommands) {
            $metaSubcmds = $Metadata.subcommands | ForEach-Object { $_.name }
        }
        foreach ($key in $Routes.Keys) {
            if ($key -eq 'default') { continue }
            if ($metaSubcmds -and $key -notin $metaSubcmds) {
                Write-Warning "[PHRouter] Route '$key' not found in metadata subcommands for '$ModuleName'."
            }
        }
    }

    # ── Resolve subcommand ────────────────────────────────────────────────────
    $subcommand = if ($ArgumentList.Count -gt 0) { $ArgumentList[0] } else { $null }
    $restArgs   = if ($ArgumentList.Count -gt 1) { $ArgumentList[1..($ArgumentList.Count - 1)] } else { @() }

    # Handle empty / no subcommand
    if (-not $subcommand -or $subcommand -eq '') {
        if ($Routes.ContainsKey('default')) {
            $target = $Routes['default']
            _PHRouter_Invoke $target $restArgs
        } else {
            _PHRouter_NoRoute $ModuleName $Routes $null $Theme
        }
        return
    }

    # Normalize subcommand (lower-case matching)
    $subLower = $subcommand.ToLower()

    # Exact match
    $matchedKey = $null
    foreach ($key in $Routes.Keys) {
        if ($key.ToLower() -eq $subLower) { $matchedKey = $key; break }
    }

    if ($matchedKey) {
        $target = $Routes[$matchedKey]
        _PHRouter_Invoke $target $restArgs
        return
    }

    # ── Fuzzy "Did you mean?" fallback ────────────────────────────────────────
    _PHRouter_NoRoute $ModuleName $Routes $subcommand $Theme
}

# ── Private: Invoke a route (scriptblock or function name string) ─────────────
function _PHRouter_Invoke {
    param(
        [Parameter(Mandatory = $true)][object]$Target,
        [Parameter(Mandatory = $false)][string[]]$RestArgs = @()
    )
    if ($Target -is [scriptblock]) {
        & $Target $RestArgs
    } elseif ($Target -is [string]) {
        if (Get-Command $Target -ErrorAction SilentlyContinue) {
            & $Target @RestArgs
        } else {
            Write-Warning "[PHRouter] Function '$Target' not found in session scope."
        }
    } else {
        Write-Warning "[PHRouter] Unsupported route type: $($Target.GetType().Name)"
    }
}

# ── Private: Fuzzy distance (Levenshtein) and no-route error message ──────────
function _PHRouter_NoRoute {
    param(
        [string]$ModuleName,
        [hashtable]$Routes,
        [string]$Subcommand,
        [object]$Theme = 'default'
    )

    $themeObj = $null
    if ($Theme -is [hashtable]) {
        $themeObj = $Theme
    } else {
        $themeObj = Get-PHTheme -Name $Theme
    }

    $routeKeys = @($Routes.Keys | Where-Object { $_ -ne 'default' } | Sort-Object)

    if ($Subcommand) {
        $unknownText = Format-ThemeText -String "Unknown subcommand:" -Theme $themeObj -Element 'ParamReq'
        $subtext = Format-ThemeText -String "'$Subcommand'" -Theme $themeObj -Element 'ParamName'
        Write-Host "${unknownText} ${subtext}"

        # Levenshtein distance for fuzzy suggest
        $suggestions = foreach ($key in $routeKeys) {
            [pscustomobject]@{ key = $key; dist = (_PHRouter_Levenshtein $Subcommand $key) }
        }
        $best = $suggestions | Sort-Object dist | Select-Object -First 3 | Where-Object { $_.dist -le 4 }
        if ($best) {
            Write-Host ""
            $didYouMeanText = Format-ThemeText -String "Did you mean?" -Theme $themeObj -Element 'ParamDesc'
            Write-Host $didYouMeanText
            foreach ($b in $best) {
                $bkeyText = Format-ThemeText -String "  $($b.key)" -Theme $themeObj -Element 'ParamName'
                Write-Host $bkeyText
            }
        }
    }

    $availStart = Format-ThemeText -String "Available subcommands for " -Theme $themeObj -Element 'ParamDesc'
    $modNameText = Format-ThemeText -String $ModuleName -Theme $themeObj -Element 'Header'
    $availEnd = Format-ThemeText -String ":" -Theme $themeObj -Element 'ParamDesc'
    Write-Host ""
    Write-Host "${availStart}${modNameText}${availEnd}"
    foreach ($key in $routeKeys) {
        $keyText = Format-ThemeText -String "  $key" -Theme $themeObj -Element 'ParamName'
        Write-Host $keyText
    }
    Write-Host ""
}

# ── Private: Iterative Levenshtein distance ───────────────────────────────────
function _PHRouter_Levenshtein {
    param([string]$a, [string]$b)
    $a = $a.ToLower()
    $b = $b.ToLower()
    $lenA = $a.Length
    $lenB = $b.Length
    if ($lenA -eq 0) { return $lenB }
    if ($lenB -eq 0) { return $lenA }

    $prev = 0..$lenB
    $curr = [int[]]::new($lenB + 1)

    for ($i = 1; $i -le $lenA; $i++) {
        $curr[0] = $i
        for ($j = 1; $j -le $lenB; $j++) {
            $cost = if ($a[$i-1] -eq $b[$j-1]) { 0 } else { 1 }
            $curr[$j] = [Math]::Min(
                [Math]::Min($curr[$j-1] + 1, $prev[$j] + 1),
                $prev[$j-1] + $cost
            )
        }
        $prev = $curr.Clone()
    }
    return $prev[$lenB]
}
