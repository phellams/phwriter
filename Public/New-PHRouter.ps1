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
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = "Subcommand route map.")]
        [hashtable]$Routes,

        [Parameter(Mandatory = $false, Position = 1, ValueFromRemainingArguments = $false, HelpMessage = "Raw argument array.")]
        [string[]]$ArgumentList = @(),

        [Parameter(Mandatory = $false, HelpMessage = "Module/CLI name for messaging.")]
        [string]$ModuleName = 'PHRouter',

        [Parameter(Mandatory = $false, HelpMessage = "Auto-register tab-completion for subcommand keys.")]
        [switch]$RegisterCompleter,

        [Parameter(Mandatory = $false, HelpMessage = "PHWriter metadata for validation.")]
        [object]$Metadata
    )

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
            _PHRouter_NoRoute $ModuleName $Routes $null
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
    _PHRouter_NoRoute $ModuleName $Routes $subcommand
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
        [string]$Subcommand
    )

    $esc    = [char]27
    $reset  = "${esc}[0m"
    $red    = "${esc}[38;5;196m"
    $yellow = "${esc}[38;5;226m"
    $cyan   = "${esc}[38;5;51m"
    $dim    = "${esc}[38;5;243m"
    $bold   = "${esc}[1m"

    $routeKeys = @($Routes.Keys | Where-Object { $_ -ne 'default' } | Sort-Object)

    if ($Subcommand) {
        Write-Host "${red}${bold}Unknown subcommand:${reset} ${yellow}'$Subcommand'${reset}"

        # Levenshtein distance for fuzzy suggest
        $suggestions = foreach ($key in $routeKeys) {
            [pscustomobject]@{ key = $key; dist = (_PHRouter_Levenshtein $Subcommand $key) }
        }
        $best = $suggestions | Sort-Object dist | Select-Object -First 3 | Where-Object { $_.dist -le 4 }
        if ($best) {
            Write-Host ""
            Write-Host "${dim}Did you mean?${reset}"
            foreach ($b in $best) {
                Write-Host "  ${cyan}${bold}$($b.key)${reset}"
            }
        }
    }

    Write-Host ""
    Write-Host "${dim}Available subcommands for ${yellow}${bold}$ModuleName${reset}${dim}:${reset}"
    foreach ($key in $routeKeys) {
        Write-Host "  ${cyan}${bold}$key${reset}"
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
