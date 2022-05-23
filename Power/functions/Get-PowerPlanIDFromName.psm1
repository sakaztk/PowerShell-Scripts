function Get-PowerPlanIDFromName {
    Param (
        [Parameter(mandatory=$true)]
        [Alias('ElementName')]
        [String]$Name,
        [ValidateSet('GUID','InstanceID')]
        [String]$Type = 'GUID'
    )
    Process {
        $targetPlan = Get-CimInstance -Class Win32_PowerPlan -Namespace root/CIMV2/power | Where-Object {$_.ElementName -eq $Name}
        switch ($Type) {
            'GUID' {
                $ret = $targetPlan.InstanceID -replace '.*({[^}]+})', '$1'
            }
            'InstanceID' {
                $ret = $targetPlan.InstanceID
            }
        }
        return $ret
    }
}