@{
    ModuleVersion     = '0.4.1'
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
            ReleaseNotes = @()
            RequireLicenseAcceptance = $false
            LicenseUri               = 'https://choosealicense.com/licenses/mit'
            ProjectUri               = 'https://gitlab.com/phellams/zypline.git'
            IconUri                  = 'https://raw.githubusercontent.com/phellams/phellams-general-resources/main/logos/zypline/dist/png/zypline-logo-128x128.png'
            # CHOCOLATE ---------------------
            LicenseUrl               = 'https://choosealicense.com/licenses/mit'
            ProjectUrl               = 'https://github.com/phellams/zypline'
            IconUrl                  = 'https://raw.githubusercontent.com/phellams/phellams-general-resources/main/logos/zypline/zypline-logo-128x128.png'
            Docsurl                  = 'https://pages.gitlab.io/sgkens/ptoml'
            MailingListUrl           = 'https://github.com/phellams/zypline/issues'
            projectSourceUrl         = 'https://github.com/phellams/zypline'
            bugTrackerUrl            = 'https://github.com/phellams/zypline/issues'
            Summary                  = 'A PowerShell module for advanced file and folder searching with configuration management.'
            # CHOCOLATE ---------------------
            Prerelease               = 'prerelease'
        }
    }
}
