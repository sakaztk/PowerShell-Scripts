#.ExternalHelp Set-AutoLogon.psm1-Help.xml
function Set-AutoLogon {
    [CmdletBinding()]
    Param (
        [Parameter(
            Position = 1,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [System.String]$UserName
        ,
        [Parameter(
            Position = 2,
            ValueFromPipelineByPropertyName = $true
        )]
        [System.Security.SecureString]$Password = ''
        ,
        [Parameter(
            Position = 3,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateScript({$_ -ge 1})]
        [Int32]$AutoLogonCount = 1
        ,
        [Parameter(
            Position = 4,
            ValueFromPipelineByPropertyName = $true
        )]
        [Switch]$Passthru
    )
    Begin {
        $keyPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
    }
    Process {
        $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
        $plainPassword  = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
        Set-ItemProperty $keyPath -name 'AutoAdminLogon' -value 1
        Set-ItemProperty $keyPath -name 'DefaultUserName' -value $UserName
        Set-ItemProperty $keyPath -name 'DefaultPassword' -value $plainPassword
        Set-ItemProperty $keyPath -name 'AutoLogonCount' -value $AutoLogonCount
        if ( $Passthru ){
            Get-AutoLogon
        }
    }
}