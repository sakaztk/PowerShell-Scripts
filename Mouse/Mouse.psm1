#Requires -Version 5
Set-Variable -Name MOUSEEVENTF_MOVE -Value 0x0001 -Option Constant -Scope Global
Set-Variable -Name MOUSEEVENTF_LEFTDOWN -Value 0x0002 -Option Constant -Scope Global
Set-Variable -Name MOUSEEVENTF_LEFTUP -Value 0x0004 -Option Constant -Scope Global
Set-Variable -Name MOUSEEVENTF_RIGHTDOWN -Value 0x0008 -Option Constant -Scope Global
Set-Variable -Name MOUSEEVENTF_RIGHTUP -Value 0x0010 -Option Constant -Scope Global
Set-Variable -Name MOUSEEVENTF_MIDDLEDOWN -Value 0x0020 -Option Constant -Scope Global
Set-Variable -Name MOUSEEVENTF_MIDDLEUP -Value 0x0040 -Option Constant -Scope Global
Set-Variable -Name MOUSEEVENTF_XDOWN -Value 0x0080 -Option Constant -Scope Global
Set-Variable -Name MOUSEEVENTF_XUP -Value 0x0100 -Option Constant -Scope Global
Set-Variable -Name MOUSEEVENTF_WHEEL -Value 0x0800 -Option Constant -Scope Global
Set-Variable -Name MOUSEEVENTF_HWHEEL -Value 0x01000 -Option Constant -Scope Global
Set-Variable -Name MOUSEEVENTF_ABSOLUTE -Value 0x8000 -Option Constant -Scope Global

Get-ChildItem -Recurse $PSScriptRoot *.cs | ForEach-Object {
    $csCode = Get-Content -Path $_.FullName -Encoding UTF8 -Raw
    Add-Type -ErrorAction Stop -Language CSharp -TypeDefinition $csCode
}
Get-ChildItem -Recurse $PSScriptRoot *.psm1 | ForEach-Object {
    if ( $_.FullName -ne $PSCommandPath ) {
        Import-Module $_.FullName
    }
}
Export-ModuleMember -Function *