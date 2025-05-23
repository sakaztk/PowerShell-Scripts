<#
.SYNOPSIS
    全受信トラフィックブロックを設定します。
 
.PARAMETER ProfileType
    対象プロファイルを NET_FW_PROFILE2_ の値で指定します。省略時はカレントプロファイルに設定します。
    NET_FW_PROFILE2_DOMAIN = 1
    NET_FW_PROFILE2_PRIVATE = 2
    NET_FW_PROFILE2_PUBLIC = 4
 #>
function Set-FwBlockAllInboundTraffic {
    [CmdletBinding()]
    Param (
        [Parameter(ValueFromPipeline=$true)]
        [ValidateSet(1,2,4,2147483647)]
        [Int]$ProfileType,
        [bool]$Enable = $true
    )
    Begin {
        $fwPolicy2 = New-Object -ComObject HNetCfg.FwPolicy2
        if ($ProfileType -eq 0) {
            $ProfileType = $fwPolicy2.CurrentProfileTypes
        }
    }
    Process {
        if ($profileType -eq 2147483647) {
            @(1,2,4) | ForEach-Object {
                $fwPolicy2.BlockAllInboundTraffic($_) = $Enable
                New-Object -TypeName PSObject -Property @{
                    NET_FW_PROFILE2_ = $_
                    BlockAllInboundTraffic = $fwPolicy2.BlockAllInboundTraffic($_)
                } | Select-Object NET_FW_PROFILE2_, BlockAllInboundTraffic
            }
        }
        else {
            $fwPolicy2.BlockAllInboundTraffic($ProfileType) = $Enable
            New-Object -TypeName PSObject -Property @{
                NET_FW_PROFILE2_ = $ProfileType
                BlockAllInboundTraffic = $fwPolicy2.BlockAllInboundTraffic($ProfileType)
            } | Select-Object NET_FW_PROFILE2_, BlockAllInboundTraffic
        }
    }
}