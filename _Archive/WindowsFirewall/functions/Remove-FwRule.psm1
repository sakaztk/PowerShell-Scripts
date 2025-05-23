#Remove-NetFirewallRule
function Remove-FwRule {
    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipeline=$true)]
        [Parameter(Mandatory=$true)]
        [String]$Name
    )
    Begin {
        $fwPolicy2 = New-Object -ComObject HNetCfg.FwPolicy2
    }
    Process {
        $fwPolicy2.Rules.Remove($Name)
    }
}