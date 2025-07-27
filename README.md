# PHWriter


## Overview

PHWriter is a PowerShell module designed to generate beautifully formatted, colored help text for your PowerShell cmdlets, mimicking the style and readability of Linux man pages. It allows you to define your cmdlet's parameters and their descriptions in a structured way, providing a consistent and professional look for your command-line help.
Features

 - Customizable Layout: Control indentation and spacing between parameter elements.
 - Colored Output: Enhance readability with distinct colors for different help sections and parameter components.

 - ASCII Art Logo: Includes a simple, elegant ASCII art banner for visual appeal.

- Inline/Newline Descriptions: Choose whether parameter descriptions appear on the same line or a new line.

- Automatic Alignment: Dynamically calculates padding to ensure perfect alignment of parameter types and descriptions.

- Production Ready: Comes with a module manifest (.psd1) for proper PowerShell module management.

## Installation

### Manual

Download the PHWriter module from GitHub and place it in your PowerShell Modules folder (e.g., C:\Users\<username>\Documents\WindowsPowerShell\Modules\PHWriter).

  1. Clone the repository: git clone https://github.com/your-username/PHWriter.git
  2. Open a PowerShell session and navigate to the cloned repository directory.
  3. Run the following command to install the module: `Import-Module .\PHWriter.psm1` or `import-module .\`
  4. Test the module by running `Get-Command -Module PHWriter` or `Get-Module -Name PHWriter`

### PowerShell Gallery

Install the PHWriter module from the PowerShell Gallery using the following command:

  1. Download the module: `Install-Module -Name PHWriter -Repository PSGallery`
  > Note that you might need to run this command as an administrator to install the module, and set the execution policy to "RemoteSigned" or "Unrestricted" if prompted.
  2. Import the module: `Import-Module -Name PHWriter`
  3. Test the module by running `Get-Command -Module PHWriter` or `Get-Module -Name PHWriter`


## Usage

The primary cmdlet provided by this module is New-PHWriter. Generates formatted help text based on an array of hashtables defining your cmdlet's parameters.

#### 🏮 New-PHWriter

```powershell
New-PHWriter -HelpTable <Hashtable[]> [-Padding <Int>] [-Indent <Int>]
```

**Parameters**

  - **HelpTable** `<Hashtable[]>` Type: System.Array
    - **Description**: A mandatory array of hashtables. Each hashtable defines a parameter for which help text will be generated and must contain the following properties:
      - **Name** (string): The full name of the parameter.
      - **Param** (string): The parameter alias(es) (e.g., "p|Path").
      - **Type** (string): The data type of the parameter (e.g., "string", "switch", "int").
      - **Description** (string): A brief explanation of the parameter's purpose.
      - **Inline** (boolean): If $true, the description appears on the same line as the parameter definition. If $false, it appears on a new, indented line.
  - **Padding** <Int> Type: System.Int32
    - **Description**: The number of spaces for padding between the parameter alias/name, type, and description columns. Defaults to 4.
  - **Indent** <Int> Type: System.Int32
    - Description: The number of spaces for left indentation of the entire help output block. Defaults to 4.

**Example**

```powershell
# Define the parameters for your custom cmdlet's help
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
```

> Generate the formatted help output with custom padding and indent

```powershell
New-PHWriter -HelpTable $myCmdletParams -Padding 6 -Indent 2
```

## Contributing

Contributions are welcome! If you have suggestions for improvements or find any issues, please open an issue or submit a pull request on the GitHub repository.

## 📑 License

This project is licensed under the MIT License - see the LICENSE file for details.