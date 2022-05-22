#(Get-NetFirewallProfile).DefaultInboundAction
function Get-FwDefaultInboundAction {
    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateSet(1,2,4,2147483647)]
        [Int]$ProfileType,
        [Switch]$All
    )
    Begin {
        $fwPolicy2 = New-Object -ComObject HNetCfg.FwPolicy2
        if ($ProfileType -eq 0) {
            $ProfileType = $fwPolicy2.CurrentProfileTypes
        }
    }
    Process {
        if (($profileType -eq 2147483647) -or $All)
        {
            @(1,2,4) | ForEach-Object {
                if ($All) {
                    New-Object -TypeName PSObject -Property @{
                        NET_FW_PROFILE2_ = $_
                        DefaultInboundAction = $fwPolicy2.DefaultInboundAction($_)
                    } | Select-Object NET_FW_PROFILE2_, DefaultInboundAction
                }
            }
        }
        else {
            New-Object -TypeName PSObject -Property @{
                NET_FW_PROFILE2_ = $ProfileType
                DefaultInboundAction = $fwPolicy2.DefaultInboundAction($ProfileType)
            } | Select-Object NET_FW_PROFILE2_, DefaultInboundAction
        }
    }
}