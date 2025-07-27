import-module .\

$myCmdletParams = @(
    @{
        Name        = "SourcePath"
        Param       = "s|Source"
        Type        = "string"
        Description = "Specifies the source path for the operation. Wildcards are supported."
        Inline      = $false # Description on a new line
    },
    @{
        Name        = "DestinationPath"
        Param       = "d|Destination"
        Type        = "string"
        Description = "Specifies the destination path where files will be copied."
        Inline      = $true  # Description on the same line
    },
    @{
        Name        = "Recurse"
        Param       = "r|Recurse"
        Type        = "switch"
        Description = "Indicates that the operation should process subdirectories recursively."
        Inline      = $false
    },
    @{
        Name        = "Confirm"
        Param       = "c|Confirm"
        Type        = "switch"
        Description = "Prompts you for confirmation before running the cmdlet. (CommonParameter)"
        Inline      = $true
    }
)

New-PHWriter -HelpTable $myCmdletParams -Padding 6 -Indent 2