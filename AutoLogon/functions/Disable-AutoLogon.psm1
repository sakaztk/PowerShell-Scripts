#.ExternalHelp Disable-AutoLogon.psm1-Help.xml
Function Disable-AutoLogon
{
    [CmdletBinding()]
    Param(
        [Parameter(
            ValueFromPipelineByPropertyName = $true
        )]
        [Switch]$Passthru
    )
    Begin {
        $keyPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
    }
    Process {
        Set-ItemProperty $keyPath -name 'AutoAdminLogon' -value 0 -ErrorAction Inquire
        if ( $Passthru ){
            Get-AutoLogon
        }
    }
}