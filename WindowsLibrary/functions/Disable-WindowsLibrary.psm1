function Disable-WindowsLibrary {
    [CmdletBinding()]
    Param(
        [Switch]$Passthru
    )
    Process {
        try {
            Set-ItemProperty `
                -Path 'HKCU:\Software\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}' `
                -Name 'System.IsPinnedToNameSpaceTree' `
                -Value 0
            Write-Verbose 'Disabled Windows Library.'
        }
        catch {
            throw
        }
        if ( $Passthru ) {
            Get-WindowsLibrary
        }    
    }
}