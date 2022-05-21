function Get-PowerSettingIdFromName {
    Param (
        [Parameter(mandatory=$true)]
        [Alias('ElementName')]
        [String]$Name,
        [ValidateSet('GUID','InstanceID')]
        [String]$Type = 'GUID'
    )
    Process {
        $targetSetting = Get-CimInstance -Class Win32_PowerSetting -Namespace root/CIMV2/power | Where-Object {$_.ElementName -eq $Name}
        switch ($Type) {
            'GUID' {
                $ret = $targetSetting.InstanceID -replace '.*({[^}]+})', '$1'
            }
            'InstanceID' {
                $ret = $targetSetting.InstanceID
            }
        }
        return $ret
    }
}