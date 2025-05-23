#Disable-NetFirewallRule -Group
function Set-FwRuleGroup
{
    [CmdletBinding()]
    Param (
        [ValidateSet(1,2,4,2147483647)]
        [Int]$ProfileType,
        [Parameter(Mandatory=$true)]
        [String]$GroupName,
        [Parameter(Mandatory=$true)]
        [bool]$Enable
    )
    Begin {
        $fwPolicy2 = New-Object -ComObject HNetCfg.FwPolicy2
        if ($ProfileType -eq 0) { $ProfileType = $fwPolicy2.CurrentProfileTypes }
    }
    Process {
        $fwPolicy2.EnableRuleGroup($ProfileType, $GroupName, $Enable)
    }
}