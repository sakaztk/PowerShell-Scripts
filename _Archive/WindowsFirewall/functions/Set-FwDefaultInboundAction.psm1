#Set-NetFirewallProfile -DefaultInboundAction
function Set-FwDefaultInboundAction {
    [CmdletBinding()]
    Param (
        [Int]$Action,
        [Parameter(ValueFromPipeline=$true)]
        [ValidateSet(1,2,4,2147483647)]
        [Int]$ProfileType,
        [Switch]$All
    )
    Begin {
        $fwPolicy2 = New-Object -ComObject HNetCfg.FwPolicy2
        if ($ProfileType -eq 0) { $ProfileType = $fwPolicy2.CurrentProfileTypes }
    }
    Process {
        if (($profileType -eq 2147483647) -or $All) {
            $targets = @(1,2,4)
        }
        else {
            $targets = @($profileType)
        }
        $targets | ForEach-Object {
            if($fwPolicy2.DefaultInboundAction($_) -eq $Action) {
                $status = 'Already'
            }
            else {
                try {
                    $fwPolicy2.DefaultInboundAction($_) = $Action
                    $status = 'OK'
                    $err = $null
                }
                catch {
                    $status = 'NG'
                    $err = $Error[0]
                }
            }
            New-Object -TypeName PSObject -Property @{
                NET_FW_PROFILE2_ = $_
                DefaultInboundAction = $fwPolicy2.DefaultInboundAction($_)
                Result = $status
                Error = $err
            } | Select-Object NET_FW_PROFILE2_, DefaultInboundAction, Result, Error
        }
    }
}