function Test-FwRuleGroupCurrentlyEnabled {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [String]$GroupName
    )
    Begin {
        $fwPolicy2 = New-Object -ComObject HNetCfg.FwPolicy2
        If ($ProfileType -eq 0) { $ProfileType = $fwPolicy2.CurrentProfileTypes }
    }
    Process {
        $fwPolicy2.IsRuleGroupCurrentlyEnabled($GroupName)
    }
}