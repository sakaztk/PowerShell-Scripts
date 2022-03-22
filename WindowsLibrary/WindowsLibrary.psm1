#Requires -Version 5
Set-Variable -Scope Local -Option Constant -Name DefaultLibraryPath -Value (Join-Path $env:APPDATA '\Microsoft\Windows\Libraries')
Set-Variable -Scope Local -Option Constant -Name LibraryExt -Value '.library-ms'
Set-Variable -Scope Local -Option Constant -Name RegKey_Library -Value 'HKCU:\Software\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}'
Set-Variable -Scope Local -Option Constant -Name RegValue_ShowLibrary -Value 'System.IsPinnedToNameSpaceTree'
Set-Variable -Scope Local -Option Constant -Name CurrentUserSid -Value ([System.Security.Principal.WindowsIdentity]::GetCurrent()).user.value
Set-Variable -Scope Local -Option Constant -Name DefaultXmlContent -Value @"
<?xml version="1.0" encoding="UTF-8"?>
<libraryDescription xmlns="http://schemas.microsoft.com/windows/2009/library">
  <ownerSID>$currentUserSid</ownerSID>
  <version>1</version>
  <isLibraryPinned>true</isLibraryPinned>
</libraryDescription>
"@

Get-ChildItem -Recurse $PSScriptRoot *.psm1 | ForEach-Object {
    if ( $_.FullName -ne $PSCommandPath ) {
        Import-Module $_.FullName
    }
}
Export-ModuleMember -Function *