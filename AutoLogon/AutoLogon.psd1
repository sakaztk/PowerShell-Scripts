@{
    GUID = '67a2bdbe-d8b4-44d5-904f-581015c00483'
    Author = 'Kazutaka Sakoda'
    CompanyName = 'Sakoda'
    ModuleVersion = '1.0.0.0'
    PowerShellVersion='3.0'
    Copyright = '(c) Sakoda. All rights reserved.'
    RootModule = 'AutoLogon.psm1'
    FunctionsToExport = @(
        'Get-AutoLogon',
        'Set-AutoLogon',
        'Disable-AutoLogon',
        'Show-Autologon'
    )
    CmdletsToExport = @()
    AliasesToExport = @()
}