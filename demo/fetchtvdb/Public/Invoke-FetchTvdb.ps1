function Invoke-FetchTvdb {
    <#
    .SYNOPSIS
      A CLI client and router for TheTVDB API.
    .DESCRIPTION
      Provides subcommand routing and CLI access to series, episodes, movies, actors, and artwork information from TheTVDB database.
    .PARAMETER Mode
      The subcommand/operation mode to execute (e.g. search, get-series, list-episodes).
    .PARAMETER Args
      Remaining arguments to pass to the subcommand.
    .PARAMETER Help
      Show main help documentation via interactive pager.
    #>
    [CmdletBinding(DefaultParameterSetName = 'Execute')]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'Execute', Position = 0)]
        [string]$Mode,

        [Parameter(Mandatory = $false, ParameterSetName = 'Execute', ValueFromRemainingArguments = $true)]
        [string[]]$Args = @(),

        [Parameter(Mandatory = $true, ParameterSetName = 'Help')]
        [switch]$Help
    )

    process {
        # Initialize routing table
        $Routes = @{
            'search' = {
                param($Remaining)
                $helpKeywords = @('help', '-help', '--help', '-h', 'h')
                if ($Remaining -and ($Remaining[0].ToLower() -in $helpKeywords)) {
                    $searchParams = @(
                        @{ name = "Query"; param = "q|Query"; type = "String"; required = $true; description = "The search query string (title, alias, or external ID)." },
                        @{ name = "Lang"; param = "l|Lang"; type = "String"; required = $false; description = "Two-letter language code to filter results (e.g. 'en', 'es')." }
                    )
                    $searchInfo = @{
                        cmdlet      = "Invoke-FetchTvdb search"
                        synopsis    = "Invoke-FetchTvdb -Mode search [-Query <String>] [-Lang <String>]"
                        description = "Queries TheTVDB database for series matching the query title. Caches results in the local SQLite database."
                    }
                    New-PHWriter -Name "FetchTVDB" -CommandInfo $searchInfo -ParamTable $searchParams -Theme "phwriter" -SourceType "router" -OutMode "Standard"
                    return
                }
                Write-Host "Executing 'search' with arguments: $Remaining"
            }
        }

        # Dynamically populate the rest of the 30 routes to keep the file size compact
        $subcommandNames = @(
            'get-series', 'get-episode', 'get-season', 'get-actor', 'get-artwork',
            'get-genres', 'list-episodes', 'search-actor', 'get-updates', 'update-cache',
            'clear-cache', 'show-cache', 'set-token', 'get-status', 'list-languages',
            'get-movie', 'search-movie', 'list-seasons', 'get-ratings', 'export-data',
            'import-data', 'set-config', 'get-config', 'test-api', 'get-user-info',
            'get-favorites', 'add-favorite', 'remove-favorite', 'get-banners'
        )

        foreach ($name in $subcommandNames) {
            $code = @'
                param($Remaining)
                $helpKeywords = @('help', '-help', '--help', '-h', 'h')
                if ($Remaining -and ($Remaining[0].ToLower() -in $helpKeywords)) {
                    $subInfo = @{
                        cmdlet      = "Invoke-FetchTvdb SUB_NAME"
                        synopsis    = "Invoke-FetchTvdb -Mode SUB_NAME [arguments]"
                        description = "Subcommand help for SUB_NAME. Performs API request or database operation."
                    }
                    New-PHWriter -Name "FetchTVDB" -CommandInfo $subInfo -Theme "phwriter" -SourceType "router" -OutMode "Standard"
                    return
                }
                Write-Host "Executing 'SUB_NAME' mode with args: $Remaining"
'@.Replace('SUB_NAME', $name)
            $Routes[$name] = [scriptblock]::Create($code)
        }

        # Default route handles printing main help with 30 subcommands using Pager mode
        $Routes['default'] = {
            $subcommandsList = @(
                @{ name = 'search'; syntax = 'search <query>'; description = 'Search for a series on TheTVDB. Queries the API by title, alias, or external ID. Supports language filtering. Results are saved in the local DB.' },
                @{ name = 'get-series'; syntax = 'get-series <id>'; description = 'Retrieve detailed metadata for a specific series. Includes overview, status, network, first aired date, and other rich information. Returns custom structured objects.' },
                @{ name = 'get-episode'; syntax = 'get-episode <id>'; description = 'Get detailed information about a single episode by its unique ID. Returns metadata, guest stars, director, writer, runtime, and synopsis.' },
                @{ name = 'get-season'; syntax = 'get-season <id>'; description = 'Retrieve season metadata by ID.' },
                @{ name = 'get-actor'; syntax = 'get-actor <id>'; description = 'Get actor details by ID.' },
                @{ name = 'get-artwork'; syntax = 'get-artwork <id>'; description = 'Get artwork url by ID.' },
                @{ name = 'get-genres'; syntax = 'get-genres'; description = 'List all movie and series genres supported by TheTVDB.' },
                @{ name = 'list-episodes'; syntax = 'list-episodes <seriesId> [-Season <int>]'; description = 'Query and list all episodes belonging to a series. Can filter by season number if provided. Outputs in a structured table.' },
                @{ name = 'search-actor'; syntax = 'search-actor <name>'; description = 'Search actors by name.' },
                @{ name = 'get-updates'; syntax = 'get-updates [-Since <datetime>]'; description = 'Fetch a list of series and movies that have been updated on TheTVDB since a specified timestamp. Used to synchronize local cache databases with official upstream changes.' },
                @{ name = 'update-cache'; syntax = 'update-cache'; description = 'Scan local series database and fetch updates for stale items.' },
                @{ name = 'clear-cache'; syntax = 'clear-cache'; description = 'Delete all cached entries from the local database.' },
                @{ name = 'show-cache'; syntax = 'show-cache'; description = 'Print database storage metrics, table row counts, and disk file size.' },
                @{ name = 'set-token'; syntax = 'set-token <token>'; description = 'Configure bearer token.' },
                @{ name = 'get-status'; syntax = 'get-status'; description = 'Check TVDB API connection health, ping latency, rate limits, and remaining quota.' },
                @{ name = 'list-languages'; syntax = 'list-languages'; description = 'List supported languages.' },
                @{ name = 'get-movie'; syntax = 'get-movie <id>'; description = 'Retrieve detailed movie metadata, runtime, and release date.' },
                @{ name = 'search-movie'; syntax = 'search-movie <title>'; description = 'Search movie database.' },
                @{ name = 'list-seasons'; syntax = 'list-seasons <seriesId>'; description = 'List seasons.' },
                @{ name = 'get-ratings'; syntax = 'get-ratings <seriesId>'; description = 'Retrieve user rating stats, average scores, and vote counts.' },
                @{ name = 'export-data'; syntax = 'export-data <seriesId> -Path <string>'; description = 'Export fetched TVDB series and episode metadata to external files on disk. Supported formats include JSON, XML, and CSV. Replaces existing destination files if -Force is passed.' },
                @{ name = 'import-data'; syntax = 'import-data -Path <string>'; description = 'Import cached data.' },
                @{ name = 'set-config'; syntax = 'set-config -Key <string> -Value <string>'; description = 'Modify local client configuration parameters such as timeouts, connection retries, default language, and user authentication credentials securely. Changes are written to config.json.' },
                @{ name = 'get-config'; syntax = 'get-config'; description = 'Display current configuration settings.' },
                @{ name = 'test-api'; syntax = 'test-api'; description = 'Run automated diagnostics to verify TVDB API credentials, endpoints, network routing, and JSON parser compatibility.' },
                @{ name = 'get-user-info'; syntax = 'get-user-info'; description = 'Retrieve active TVDB subscriber profile and subscription details.' },
                @{ name = 'get-favorites'; syntax = 'get-favorites'; description = 'List user favorites.' },
                @{ name = 'add-favorite'; syntax = 'add-favorite <seriesId>'; description = 'Add a series to user favorites.' },
                @{ name = 'remove-favorite'; syntax = 'remove-favorite <seriesId>'; description = 'Remove a series from user favorites.' },
                @{ name = 'get-banners'; syntax = 'get-banners <seriesId>'; description = 'Fetch links to banner art, posters, fanart, and background images.' }
            )

            $CommandInfo = @{
                cmdlet      = "Invoke-FetchTvdb"
                synopsis    = "Invoke-FetchTvdb -Mode <String> [-Args <String[]>]"
                description = "A powerful, high-performance command line client for TheTVDB API, providing seamless access to series, episodes, movies, actors, and artwork information. Integrates local SQLite caching for sub-millisecond response times."
                source      = "https://gitlab.com/phellams/fetchtvdb"
            }

            New-PHWriter -Name "FetchTVDB" -Version "1.0.0" -CommandInfo $CommandInfo -Subcommands $subcommandsList -Theme "phwriter" -SourceType "router" -OutMode "Alt"
        }

        # Check if Help parameter set is active or help switch is explicitly passed
        if ($Help -or $PSCmdlet.ParameterSetName -eq 'Help') {
            & $Routes['default']
            return
        }

        # Consolidate arguments list for dispatching
        $routerArgs = @()
        if ($Mode) {
            $routerArgs += $Mode
        }
        if ($Args) {
            $routerArgs += $Args
        }

        # Execute router dispatching
        New-PHRouter -Routes $Routes -ArgumentList $routerArgs -ModuleName 'Invoke-FetchTvdb' -Theme 'phwriter'
    }
}
