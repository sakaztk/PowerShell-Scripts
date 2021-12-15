#Requires -Version 5
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