#   
# *=============================================
# Function: Write-PHAsciiLogo
# Description: Displays an ASCII art logo for the PHWriter module.
# Parameters: None
# Returns: None
# *---------------------------------------------
function Write-PHAsciiLogo {
    param(
        [parameter(mandatory = $true, HelpMessage = "Sets the Name of the module for the logo display.")]
        [string]$ModuleName = 'PHWriter' # Default module name if not provided
    )
    $logoLines = @(
        "╔═══════════════════════════════════════════════════════════╗",
        "║                      P H W R I T R                        ║",
        "╚═══════════════════════════════════════════════════════════╝"
    )

    foreach ($line in $logoLines) {
        Write-Host $line -ForegroundColor Green
    }
    Write-Host "" # Add a new line for spacing after the logo
}

# The New-PHWriter cmdlet generates formatted help text based on provided parameters.
# It supports custom layouts, coloring, and inline/newline descriptions.
# *=============================================
# Function: New-PHWriter
# Description: Generates formatted help text for PowerShell cmdlets with custom layouts and coloring.
# Parameters:
#   - HelpTable: An array of hashtables defining cmdlet parameters.
#   - Padding: Number of spaces for padding between columns.
#   - Indent: Number of spaces for left indentation of each line.
# Returns: None
# *---------------------------------------------

function New-PHWriter {
    [CmdletBinding()] # Enables common cmdlet parameters like -Verbose, -Debug, etc.
    param(
        # HelpTable is a mandatory parameter that accepts an array of hashtables.
        # Each hashtable defines a parameter for which help text will be generated.
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = "An array of hashtables defining help parameters.")]
        [array]$HelpTable,

        # Padding specifies the number of spaces between the parameter alias/name, type, and description.
        # This helps in aligning columns for a clean look.
        [Parameter(HelpMessage = "Number of spaces for padding between columns.")]
        [int]$Padding = 4, #o Default padding of 4 spaces

        # Indent specifies the left padding for each line of the help output.
        # This indents the entire help block from the left edge of the console.
        [Parameter(HelpMessage = "Number of spaces for left indentation of each line.")]
        [int]$Indent = 4 # Default indent of 4 spaces
    )

    Process {
        # Create an indentation string based on the Indent parameter.
        $indentString = " " * $Indent

        # Display the ASCII logo at the top of the help output.
        Write-PHAsciiLogo

        # Display the module version information.
        Write-Host "$indentString Phwriter version 1.2.1" -ForegroundColor Cyan
        Write-Host "" # Add a new line for spacing

        # Display the SYNOPSIS section, outlining the basic usage of the cmdlet.
        Write-Host "$indentString SYNOPSIS" -ForegroundColor Yellow
        Write-Host "$indentString     new-phwriter [-HelpTable <Hashtable[]>] [-Padding <Int>] [-Indent <Int>]" -ForegroundColor White
        Write-Host "" # Add a new line for spacing

        # Display a general DESCRIPTION of what this cmdlet does.
        Write-Host "$indentString DESCRIPTION" -ForegroundColor Yellow
        Write-Host "$indentString     This cmdlet generates formatted help text for PowerShell cmdlets" `
            "with custom layouts and coloring, mimicking a man-page style." -ForegroundColor White
        Write-Host "" # Add a new line for spacing

        # Display the PARAMETERS section header.
        Write-Host "$indentString PARAMETERS" -ForegroundColor Yellow

        # --- Calculate maximum lengths for alignment ---
        $maxParamLength = 0
        $maxTypeLength = 0

        foreach ($paramInfo in $HelpTable) {
            # Validate that all required properties are present.
            if (-not ($paramInfo.Name -and $paramInfo.Param -and $paramInfo.Type -and $paramInfo.Description -and ($paramInfo.Inline -ne $null))) {
                Write-Warning "Skipping an entry in HelpTable due to missing required properties (Name, Param, Type, Description, Inline)."
                continue
            }
            # Calculate length for the parameter alias/name part (e.g., "-p|Path").
            # Add 1 for the leading hyphen and 1 for the space after.
            $currentParamLength = ("-{0}" -f $paramInfo.Param).Length + 1 # +1 for the space after alias

            # Calculate length for the type part (e.g., "[string]").
            $currentTypeLength = ("[{0}]" -f $paramInfo.Type).Length

            if ($currentParamLength -gt $maxParamLength) {
                $maxParamLength = $currentParamLength
            }
            if ($currentTypeLength -gt $maxTypeLength) {
                $maxTypeLength = $currentTypeLength
            }
        }

        # --- Iterate and display with calculated padding ---
        foreach ($paramInfo in $HelpTable) {
            # Re-validate in case some entries were skipped during length calculation.
            if (-not ($paramInfo.Name -and $paramInfo.Param -and $paramInfo.Type -and $paramInfo.Description -and ($paramInfo.Inline -ne $null))) {
                continue # Skip if invalid
            }

            # Extract properties from the current hashtable for easier access.
            $paramName = $paramInfo.Name
            $paramAlias = $paramInfo.Param
            $paramType = $paramInfo.Type
            $paramDescription = $paramInfo.Description
            $paramInline = [bool]$paramInfo.Inline # Ensure Inline is treated as a boolean

            # Format the parameter alias/name part, applying padding.
            $formattedParamAlias = ("-{0}" -f $paramAlias).PadRight($maxParamLength + $Padding)
            # Format the type part, applying padding.
            $formattedParamType = ("[{0}]" -f $paramType).PadRight($maxTypeLength + $Padding)

            # Output the indented parameter line.
            Write-Host "$indentString $formattedParamAlias" -NoNewline -ForegroundColor Magenta
            Write-Host "$formattedParamType" -NoNewline -ForegroundColor DarkCyan
            Write-Host "$paramName" -NoNewline -ForegroundColor White

            # Handle the description display based on the 'Inline' property.
            if ($paramInline) {
                # If Inline is true, append the description on the same line.
                Write-Host " $paramDescription" -ForegroundColor Gray # Add a space before description
            }
            else {
                # If Inline is false, start the description on a new line with indentation.
                Write-Host "" # Ensure a new line after the parameter name
                # Calculate the indentation for the description based on the overall indent and column widths.
                $descriptionIndent = $indentString + (" " * ($maxParamLength + $maxTypeLength + (2 * $Padding) + 1)) # +1 for the space after param name
                Write-Host "$descriptionIndent $paramDescription" -ForegroundColor Gray
            }
            Write-Host "" # Add a new line for spacing between different parameters
        }
    }
}

$cmdlet_config = @{
    function = @(
        'New-PHWriter',
        'Write-PHAsciiLogo'
    )
    alias = @()
}

Export-ModuleMember @cmdlet_config
