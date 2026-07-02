@{
    ModuleVersion     = '0.5.0'
    GUID              = '083f04e0-3fe0-42ec-a918-f799e1f1df39'
    Author            = 'Garvey K. Snow'
    CompanyName       = 'Phallems'
    Copyright         = '(c) 2025 Phallems. All rights reserved.'
    Description       = 'PHWriter: a PowerShell module for generating colored, themed help text, auto-extracting cmdlet metadata via AST, TUI paging, and zero-boilerplate CLI routing.'
    RootModule        = 'phwriter.psm1'
    FunctionsToExport = @(
        'New-PHWriter',
        'Write-PHAsciiLogo',
        'Export-PHWriterMetadata',
        'Invoke-PHPager',
        'New-PHRouter',
        'Show-PHTheme',
        'Get-TerminalPalette'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @('phextract', 'phpager', 'phroute', 'terpal')
    PrivateData       = @{
        PSData = @{
            Tags         = @('Help', 'Formatting', 'CLI', 'PowerShell', 'Documentation', 'AST', 'TUI', 'Router', 'Themes', 'Pager')
            ReleaseNotes = @()
            RequireLicenseAcceptance = $false
            IconUri                  = 'https://raw.githubusercontent.com/phellams/phellams-general-resources/main/logos/phwriter/dist/png/phwriter-logo-128x128.png'
            LicenseUrl               = 'https://choosealicense.com/licenses/mit'
            ProjectUrl               = 'https://github.com/phellams/phwriter'
            # CHOCOLATE ---------------------
            LicenseUri               = 'https://choosealicense.com/licenses/mit'
            ProjectUri               = 'https://gitlab.com/phellams/phwriter.git'
            IconUrl                  = 'https://raw.githubusercontent.com/phellams/phellams-general-resources/main/logos/phwriter/dist/png/phwriter-logo-128x128.png'
            Docsurl                  = 'https://pages.gitlab.io/sgkens/ptoml'
            MailingListUrl           = 'https://github.com/phellams/phwriter/issues'
            projectSourceUrl         = 'https://github.com/phellams/phwriter'
            bugTrackerUrl            = 'https://github.com/phellams/phwriter/issues'
            Summary                  = 'A PowerShell module for generating custom, colored help text with a man-page-like layout.'
            chocoDescription         = @"
## Overview

PHWriter(_**Powershell Help Writer**_) is a PowerShell module designed to generate beautifully formatted, colored help text for your PowerShell cmdlets, mimicking the style and readability of Linux man pages. It allows you to define your cmdlet's parameters and their descriptions in a structured way, providing a consistent and professional look for your command-line help.
Features

 - **Customizable Layout**: Control indentation and spacing between parameter elements.
 - Colored Output: Enhance readability with distinct colors for different help sections and parameter components.
 - **ASCII Art Logo**: Includes a simple, elegant ASCII art banner for visual appeal, or you can provide your own ascii art.
 - **Inline/Newline Descriptions**: Choose whether parameter descriptions appear on the same line or a new line.
 - **Automatic Alignment**: Dynamically calculates padding to ensure perfect alignment of parameter types and descriptions.
 - **Production Ready**: Comes with a module manifest (.psd1) for proper PowerShell module management.
"@
            # CHOCOLATE ---------------------
            Prerelease               = ''
        }
    }
}
