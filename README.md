# PHWriter

![static license-badge][license-badge]

## Overview

PHWriter(_**Powershell Help Writer**_) is a PowerShell module designed to generate beautifully formatted, colored help text for your PowerShell cmdlets, mimicking the style and readability of Linux man pages. It allows you to define your cmdlet's parameters and their descriptions in a structured way, providing a consistent and professional look for your command-line help.
Features

 - **Customizable Layout**: Control indentation and spacing between parameter elements.
 - Colored Output: Enhance readability with distinct colors for different help sections and parameter components.
 - **ASCII Art Logo**: Includes a simple, elegant ASCII art banner for visual appeal, or you can provide your own ascii art.
 - **Inline/Newline Descriptions**: Choose whether parameter descriptions appear on the same line or a new line.
 - **Automatic Alignment**: Dynamically calculates padding to ensure perfect alignment of parameter types and descriptions.
 - **Production Ready**: Comes with a module manifest (.psd1) for proper PowerShell module management.

## Installation

### 📥 Manual

Download the **PHWriter** module from GitHub and place it in your PowerShell Modules folder (e.g., `C:\Users\<username>\Documents\WindowsPowerShell\Modules\PHWriter`

  1. Clone the repository: `git clone https://github.com/your-username/PHWriter.git`
  2. Open a PowerShell session and navigate to the cloned repository directory.
  3. Run the following command to install the module: `Import-Module .\PHWriter.psm1` or `import-module .\`
  4. Test the module by running `Get-Command -Module PHWriter` or `Get-Module -Name PHWriter`

### 📦 PowerShell Gallery

Install the **PHWriter** module from the **PowerShell Gallery** using the following command:

  1. Download the module: `Install-Module -Name PHWriter -Repository PSGallery`
  > Note that you might need to run this command as an administrator to install the module, and set the execution policy to "RemoteSigned" or "Unrestricted" if prompted.
  2. Import the module: `Import-Module -Name PHWriter`
  3. Test the module by running `Get-Command -Module PHWriter` or `Get-Module -Name PHWriter`


## Usage

The primary cmdlet provided by this module is `New-PHWriter`. Generates formatted help text based on an array of hashtables defining your cmdlet's parameters.

#### 🏮 New-PHWriter

🔹 Output help text

```powershell
New-PHWriter -Help
```
🔹 Generate New Help
```powershell
New-PHWriter -Name <String> `
             -CommandInfo <Hashtable> `
             -ParamTable <HashTable[]> `
             -Version <String> `
             -Examples <String[]> `
             -Padding <Int> `
             -Indent <Int> `
             -CustomLogo <String>
             -Help <Switch>

```

### **Parameters List**

 - **Name**: The name of the module to display in the header. Default: "P H W R I T E R"
 - **CommandInfo**: A hashtable containing the name and description of the cmdlet to display version information. Default: Current command name props: 'ModuleName', 'Cmdlet', 'Description'
 - **ParamTable**: An array of hashtables defining the parameters and their descriptions. Default: Empty array
 - **Examples**: An array of examples for the cmdlet. Default: Empty array
 - **Version**: The version of the module to display in the header. Default: "1.0.0"
 - **Padding**: The number of spaces between the parameter alias/name, type, and description. Default: 4
 - **Indent**: The number of spaces to indent the help text. Default: 2
 - **CustomLogo**: The logo to display at the top of the help text. Default: "P H W R I T E R"
 - **Help**: Display help for the cmdlet



**Example:**

```powershell
# Define the parameters for your custom cmdlet's help
[hashtable] $MyCommandDiscription = @{
    cmdlet = "New-PHWriter";
    synopsis = "New-PHWriter [-HelpTable <Hashtable[]>] [-Padding <Int>] [-Indent <Int>]";
    description = "This cmdlet generates formatted help text for PowerShell cmdlets with custom layouts and coloring, mimicking the style of the 'help' command. It supports custom layouts, coloring, and inline/newline descriptions. "; 
}

$myCmdletParams = @(
    @{
        Name        = "SourcePath"
        Param       = "s|Source"
        Type        = "string"
        required   = $true
        Description = "Specifies the source path for the operation. Wildcards are supported."
        Inline      = $false # Description on a new line
    },
    @{
        Name        = "DestinationPath"
        Param       = "d|Destination"
        Type        = "string"
        required   = $true
        Description = "Specifies the destination path where files will be copied."
        Inline      = $false  # Description on the same line
    },
    @{
        Name        = "Recurse"
        Param       = "r|Recurse"
        Type        = "switch"
        required   = $false
        Description = "Indicates that the operation should process subdirectories recursively."
        Inline      = $false
    },
    @{
        Name        = "Confirmation"
        Param       = "c|Confirm"
        Type        = "switch"
        required   = $false
        Description = "Prompts you for confirmation before running the cmdlet. (CommonParameter)"
        Inline      = $false
    }
)
$myCmdletexamples = @(
    "New-PHWriter -SourcePath 'C:\Source' -DestinationPath 'C:\Destination' -Recurse",
    "New-PHWriter -SourcePath 'C:\Source\*' -DestinationPath 'C:\Destination' -Confirm",
    "New-PHWriter -SourcePath 'C:\Source' -DestinationPath 'C:\Destination' -Recurse -Confirm",
    "New-PHWriter -SourcePath 'C:\Source\*' -DestinationPath 'C:\Destination' -Recurse -Confirm"
)


New-PHWriter -Name "PHWRITER" `
             -ParamTable $myCmdletParams `
             -CommandInfo $MyCommandDiscription `
             -Examples $myCmdletexamples `
             -Version "1.2.1" `
             -Padding 6 `
             -Indent 2
```

**Generate the formatted help output with custom padding and indent:**

```powershell
New-PHWriter -HelpTable $myCmdletParams -Padding 6 -Indent 2
```

**Output**

```text
╔═======════════════════════════════════════════════════════════======═╗
╟░░░░░░░░░░░░░░░░░░░░░░░░░░░░P H W R I T E R░░░░░░░░░░░░░░░░░░░░░░░░░░░╢                                                               
╚═======════════════════════════════════════════════════════════======═╝

   MODULE  PHWRITER   CMDLET New-PHWriter      v1.2.1

    CMDLET SYNOPSIS
       New-PHWriter [-HelpTable <Hashtable[]>] [-Padding <Int>] [-Indent <Int>]

    DESCRIPTION
       This cmdlet generates formatted help text for PowerShell cmdlets with custom layouts and
       coloring, mimicking the style of the 'help' command. It supports custom layouts, coloring, and
       inline/newline descriptions.


    PARAMETERS

     -s|Source            [string]       (Req)  SourcePath
                                          Specifies the source path for the operation. Wildcards are supported.
     -d|Destination       [string]       (Req)  DestinationPath
                                          Specifies the destination path where files will be copied.
     -r|Recurse           [switch]        Recurse
                                          Indicates that the operation should process subdirectories recursively.
     -c|Confirm           [switch]        Confirmation
                                          Prompts you for confirmation before running the cmdlet. (CommonParameter)
   EXAMPLES

     New-PHWriter -SourcePath 'C:\Source' -DestinationPath 'C:\Destination' -Recurse

     New-PHWriter -SourcePath 'C:\Source\*' -DestinationPath 'C:\Destination' -Confirm

     New-PHWriter -SourcePath 'C:\Source' -DestinationPath 'C:\Destination' -Recurse -Confirm

     New-PHWriter -SourcePath 'C:\Source\*' -DestinationPath 'C:\Destination' -Recurse -Confirm
```

## Contributing

Contributions are welcome! If you have suggestions for improvements or find any issues, please open an issue or submit a pull request on the GitHub repository.

## 📑 License

This project is licensed under the MIT License - see the LICENSE file for details.


[license-badge]: https://img.shields.io/badge/License-MIT-Blue?style=for-the-badge&labelColor=%232D2D34&color=%2317202a