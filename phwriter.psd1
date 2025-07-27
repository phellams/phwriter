@{
    ModuleVersion     = '1.2.1'
    GUID              = 'b40e340a-9d6c-4f7f-8c3b-2a7f8e0d9c1a'
    Author            = 'Garvey K. Snow'
    CompanyName       = 'Phallems'
    Copyright         = '(c) 2025 Phallems. All rights reserved.'
    Description       = 'A PowerShell module for generating custom, colored help text with a man-page-like layout.'
    RootModule        = 'PHWriter.psm1'
    FunctionsToExport = @('New-PHWriter', 'Write-PHAsciiLogo')
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
    PrivateData       = @{
        PSData = @{
            Tags         = @('Help', 'Formatting', 'CLI', 'PowerShell', 'Documentation')
            ReleaseNotes = @{
                '1.2.1' = 'Initial release with New-PHWriter cmdlet for custom help formatting and enhanced layout.'
            }
        }
    }
}
