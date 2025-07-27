using module .\cmdlets\Format-StringWithCharSpacesAndHyphens.psm1
# using module .\cmdlets\psparagraph\libs\New-Paragraph.psm1
using module .\cmdlets\New-ColorConsole.psm1

# From psparagraph module
function New-Paragraph() {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [
        Parameter(
            Mandatory = $true
        )
        ][int]$position,

        [
        Parameter(
            Mandatory = $true
        )
        ][int]$indent,
       
        [  
        Parameter(
            Mandatory = $true
        )
        ]
        [string]$string
    )

    return [Indenter]::NewIndent($position, $indent, $string)

}

# *=============================================
# Function: Write-PHAsciiLogo
# Description: Displays an ASCII art logo for the PHWriter module.
# Parameters: None
# Returns: None
# *---------------------------------------------
function Write-PHAsciiLogo {
    param(
        [parameter(mandatory = $true, HelpMessage = "Sets the Name of the module for the logo display.")]
        [string]$Name, # Default module name if not provided
        [parameter(mandatory = $false, HelpMessage = "Sets a custom logo for the module display.")]
        [string]$CustomLogo = $null # Optional custom logo, if provided
    )
    
    $logoLines = @()

    # if no name provided and custom logo is not set, use default logo
    if(!$CustomLogo) {
        $Name_Spaced = Format-StringWithCharSpacesAndHyphens -InputString $Name # Format the name with spaces and hyphens
        # Elements
        $top_border = "`╔═======════════════════════════════════════════════════════════======═╗"
        $bottom_border = "`╚═======════════════════════════════════════════════════════════======═╝"
        [int]$padding_left = ($top_border.Length) - ($top_border.Length / 2 ) - ($Name_Spaced.Length / 2) - 1 # Calculate padding for left side
        [int]$padding_right  = $null
        if ($Name.Length % 2 -eq 0) { 
            # write-host "Value is even"
            $padding_right = $padding_left - 1  # If even, add one more space to the right
        } 
        if ($Name.Length % 2 -eq 1) { 
            # write-host "Value is odd"
            $padding_right = $padding_left + 1 # If odd, keep it the same as left
        }
        # Populate the logo lines
        $logoLines = @(
            $top_border,
            "╟$("░" * $padding_left)$Name_Spaced$("░" * ($padding_right))╢",
            $bottom_border
        )
    }
    else {
        # If a custom logo is provided, split it into lines
        $logoLines = $CustomLogo -split "`n" # Split the custom logo into
        # lines based on new line characters
        # Ensure each line is trimmed to remove any leading/trailing whitespace
        $logoLines = $logoLines | ForEach-Object { $_.Trim() }
        # Add borders to the custom logo lines
    }

    foreach ($line in $logoLines) {
        [console]::writeline("$($line)")
    }
    [console]::write("`n") # Add a new line for spacing after the logo
}

# The New-PHWriter cmdlet generates formatted help text based on provided parameters.
# It supports custom layouts, coloring, and inline/newline descriptions.
# *=============================================
# Function: New-PHWriter
# Description: Generates formatted help text for PowerShell cmdlets with custom layouts and coloring.
# Parameters:
#   - ParamTable: An array of hashtables defining cmdlet parameters.
#   - Padding: Number of spaces for padding between columns.
#   - Indent: Number of spaces for left indentation of each line.
# Returns: None
# *---------------------------------------------

function New-PHWriter {
    [CmdletBinding()] # Enables common cmdlet parameters like -Verbose, -Debug, etc.
    param(
        # Default module name for the logo
        [Parameter(HelpMessage = "Sets the Name of the default logo to display. default: 'P H W R I T E R'.")]
        [string]$Name, 

        # Default to the current command name props: 'ModuleName', 'Cmdlet', 'Description'
        [Parameter(Mandatory = $false, HelpMessage = "Name & Description of the cmdlet to display version information.")]
        [hashtable]$CommandInfo, 

        # ParamTable is a mandatory parameter that accepts an array of hashtables.
        # Each hashtable defines a parameter for which help text will be generated.
        [Parameter(Mandatory = $false, HelpMessage = "An array of hashtables defining help parameters.")]
        [array]$ParamTable,

        [Parameter(Mandatory = $false, HelpMessage = "Example cmdlet cmdlet calls.")]
        [string[]]$Examples, # Optional examples for the cmdlet, default is an empty array

        [Parameter(Mandatory = $false, HelpMessage = "Version of the cmdlet to display.")]
        [string]$Version, # Default version of the cmdlet

        # Padding specifies the number of spaces between the parameter alias/name, type, and description.
        # This helps in aligning columns for a clean look.
        [Parameter(HelpMessage = "Number of spaces for padding between columns.")]
        [int]$Padding = 4, # Default padding of 4 spaces

        # Indent specifies the left padding for each line of the help output.
        # This indents the entire help block from the left edge of the console.
        [Parameter(HelpMessage = "Number of spaces for left indentation of each line.")]
        [int]$Indent = 4, # Default indent of 4 spaces

        [Parameter(HelpMessage = "Sets a custom logo for the module display. If not provided, a default logo will be used.")]
        [string]$CustomLogo = $null, # Optional custom logo, if provided

        [parameter(HelpMessage = "Display Help for the cmdlet.")]
        [switch]$Help
    )

    Process {

        if(!$version){
            $Version = '1.0.0' # Default version if not provided
        }

        # Create an indentation string based on the Indent parameter.
        $indentString = " " * $Indent
        if(!$Description){$Description = "-"}
        $phwriter_ParamTable = @(
            @{
                Name        = "Name"
                Param       = "n|Name"
                Type        = "String"
                Description = "Sets the Name of the default logo to display. Default: 'P H W R I T E R'."
                Inline      = $false
            },
            @{
                Name        = "c|CommandInfo"
                Param       = "CommandInfo"
                Type        = "hashtable"
                Description = "cmdlet, synopsis, and Description of the cmdlet to display version information."
                Inline      = $false
            }, 
            @{
                Name        = "ParamTable"
                Param       = "p|ParamTable"
                Type        = "Hashtable[]"
                Description = "An array of hashtables defining help parameters."
                Inline      = $false
            },
            @{
                Name        = "Examples"
                Param       = "e|Examples"
                Type        = "string[]"
                Description = "Example cmdlet cmdlet calls."
                Inline      = $false
            },
            @{
                Name        = "Version"
                Param       = "v|Version"
                Type        = "String"
                Description = "Version of the cmdlet to display."
                Inline      = $false
            },
            @{
                Name        = "Padding"
                Param       = "pad|Padding"
                Type        = "Int"
                Description = "Number of spaces for padding between columns."
                Inline      = $false
            },
            @{
                Name        = "Indent"
                Param       = "i|Indent"
                Type        = "Int"
                Description = "Number of spaces for left indentation of each line."
                Inline      = $false
            },
            @{
                Name        = "CustomLogo"
                Param       = "CustomLogo"
                Type        = "String"
                Description = "Sets a custom logo for the module display. If not provided, a default logo will be used."
                Inline      = $false
            },
            @{
                Name        = "Help"
                Param       = "h|Help"
                Type        = "Switch"
                Description = "Display Help for the cmdlet."
                Inline      = $false
            }
        )
        $phwriter_commandinfo = @{
            cmdlet = "New-PHWriter";
            synopsis = "New-PHWriter [-HelpTable <Hashtable[]>] [-Padding <Int>] [-Indent <Int>]";
            description = "This cmdlet generates formatted help text for PowerShell cmdlets with custom layouts and coloring, mimicking the output of the 'help' command. It supports custom layouts, coloring, and inline/newline descriptions."
        }
        $phwriter_examples = @(
            'New-PHWriter -Help',
            'New-PHWriter -Name "PHWriter" -ComandInfo [Hashtable] -ParamTable [HashTable[]] -Version [String] -Padding [int] -Indent [int]',
            'New-PHWriter -Name "PHWriter" -ComandInfo [Hashtable] -ParamTable [HashTable[]] -version [String] -Padding [int] -Indent [int]'
        )
        if($Help){
            # If the Help switch is set, display the help information and exit.
            New-PHWriter -Name 'PHWRITER' -CommandInfo $phwriter_commandinfo -ParamTable $phwriter_ParamTable -Padding 4 -Indent 2 `
             -CustomLogo $CustomLogo -Version '0.3.5' -Examples $phwriter_examples
            [console]::write("`n") # Add a new line for spacing after the
            return
        }
        # Fallback to default name if not provided
        if (!$name) { $name = 'PHW' } 
        # Display the ASCII logo at the top of the help output.
        if(!$CustomLogo) {
            Write-PHAsciiLogo -Name $name
        }else{
            Write-PHAsciiLogo -CustomLogo $CustomLogo
        }
        
        #NOTE: change write-host to New-ColorConsole 4bit color with formatting
        # Display the module version information.
        [console]::write("$(csole -s "$indentString MODULE " -color Darkgray) $(csole -s $Name -color cyan -bgcolor gray)")
        [console]::write("$(csole -s "$indentString CMDLET" -color Darkgray) $(csole -s $($CommandInfo.cmdlet) -color cyan -bgcolor gray)")
        [console]::write("$indentString $(csole -s "$indentString v$Version" -color cyan)")
        [console]::write("`n`n") # Add a new line for spacing

        # Display the SYNOPSIS section, outlining the basic usage of the cmdlet.
        [console]::write("$(csole -s "$indentString" -color yellow) $(csole -s "CMDLET SYNOPSIS" -color Yellow -format bold,underline)`n")
        [console]::write("$(csole -s "$indentString     $($CommandInfo.synopsis)" -color white)")
        [console]::write("`n`n") # Add a new line for spacing

        # Display a general DESCRIPTION of what this cmdlet does.
        [console]::write("$(csole -s "$indentString" -color yellow) $(csole -s DESCRIPTION -color Yellow -format bold,underline)`n")
        #[console]::write("$(csole -s "$indentString     $($CommandInfo.description)" -color white)")
        New-Paragraph -position 100 -indent 7 -string "$(csole -s "$($CommandInfo.description)" -color white)"
        [console]::write("`n`n") # Add a new line for spacing

        # Display the PARAMETERS section header.
        if (!$ParamTable -or $ParamTable.Count -eq 0) {
            Write-Warning "No parameters provided in ParamTable. Skipping parameter display."
            return
        }else{
            [console]::write("$indentString $(csole -s PARAMETERS -color Yellow -format bold,underline)")
            [console]::write("`n`n")

        }
        # --- Calculate maximum lengths for alignment ---
        $maxParamLength = 0
        $maxTypeLength = 0

        foreach ($paramInfo in $ParamTable) {
            # Validate that all required properties are present.
            if (-not ($paramInfo.Name -and $paramInfo.Param -and $paramInfo.Type -and $paramInfo.Description -and ($paramInfo.Inline -ne $null))) {
                Write-Warning "Skipping an entry in ParamTable due to missing required properties (Name, Param, Type, Description, Inline)."
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
        foreach ($paramInfo in $ParamTable) {
            # Re-validate in case some entries were skipped during length calculation.
            if (-not ($paramInfo.Name -and $paramInfo.Param -and $paramInfo.Type -and $paramInfo.Description -and ($paramInfo.Inline -ne $null))) {
                continue # Skip if invalid
            }

            # Extract properties from the current hashtable for easier access.
            $paramName = $paramInfo.Name
            $paramAlias = $paramInfo.Param
            $paramType = $paramInfo.Type
            $paramDescription = $paramInfo.Description
            $required = $paramInfo.required -or $false # Default to false if not specified
            if ($required) { $required_text = "$(csole -string "(Req) " -color red)"; } # Append "(Req)" if required
            else { $required_text = ""; } # No text if not required
            $paramInline = [bool]$paramInfo.Inline # Ensure Inline is treated as a boolean

            # Format the parameter alias/name part, applying padding.
            $formattedParamAlias = ("-{0}" -f $paramAlias).PadRight($maxParamLength + $Padding)
            # Format the type part, applying padding.
            $formattedParamType = ("[{0}]" -f $paramType).PadRight($maxTypeLength + $Padding)

            # Output the indented parameter line.
            [console]::write("$indentString   $(csole -s "$formattedParamAlias" -color DarkMagenta)")
            [console]::write("$(csole -s $formattedParamType -color DarkCyan) $required_text")
            [console]::write("$(csole -s " $paramName" -color White)")

            # Handle the description display based on the 'Inline' property.
            if ($paramInline) {
                # If Inline is true, append the description on the same line.
                [console]::write("$(csole -s " $paramDescription" -color DarkGray)")
            }
            else {
                # If Inline is false, start the description on a new line with indentation.
                [console]::write("`n") # Ensure a new line after the parameter name
                # Calculate the indentation for the description based on the overall indent and column widths.
                $descriptionIndent = $indentString + (" " * ($maxParamLength + $maxTypeLength + (2 * $Padding) + 1)) # +1 for the space after param name
                [console]::write("$descriptionIndent $(csole -s "   $paramDescription" -color DarkGray)")
            }

            [console]::write("`n") # Add a new line for spacing between different parameters
        }
        #TODO: Implement examples for cmdlet parameters
        [console]::write("$indentString$(csole -s "EXAMPLES" -color White -format bold,underline)`n")
        foreach ($example in $Examples) {
            [console]::write("`n$indentString$(" "* 3)$(csole -s "$example" -color DarkGray)")
            # Add a new line after each example for better readability
            [console]::write("`n") # Add a new line for spacing
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
