#Requires -Version 5
Get-ChildItem -Recurse $PSScriptRoot *.psm1 | ForEach-Object {
    if ( $_.FullName -ne $PSCommandPath ) {
        Import-Module $_.FullName
    }
}
Export-ModuleMember -Function *