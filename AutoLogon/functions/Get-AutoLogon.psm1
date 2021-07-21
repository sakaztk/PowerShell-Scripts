#.ExternalHelp AutoLogon.psm1-Help.xml
function Get-AutoLogon {
    [CmdletBinding()]
    Param()
    Begin {
        $keyPath = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
    }
    Process {
        $keyValues = Get-ItemProperty -Path $keyPath
        $intEnabled = [int]$keyValues.AutoAdminLogon
        New-Object -TypeName PSObject -Property @{
            Enabled = [boolean]$intEnabled
            UserName = $keyValues.DefaultUserName
            Password = $keyValues.DefaultPassword
            AutoLogonCount = $keyValues.AutoLogonCount
        } | Select-Object Enabled, UserName, Password, AutoLogonCount
    }
}