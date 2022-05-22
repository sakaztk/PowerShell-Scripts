<#
.SYNOPSIS
    全受信トラフィックブロックの設定を取得します。
 
.PARAMETER ProfileType
    対象プロファイルを NET_FW_PROFILE2_ の値で指定します。省略時はカレントプロファイルを確認します。
    NET_FW_PROFILE2_DOMAIN = 1
    NET_FW_PROFILE2_PRIVATE = 2
    NET_FW_PROFILE2_PUBLIC = 4
 
 .INPUTS
    パイプを使用して、確認するプロファイルを Get-FwBlockAllInboundTraffic に渡すことができます。
#>
function Get-FwBlockAllInboundTraffic {
    [CmdletBinding()]
    Param(
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
        if (($profileType -eq 2147483647) -or $All)
        {
            $ret = 0
            @(1,2,4) | ForEach-Object {
                if ($All) {
                    New-Object -TypeName PSObject -Property @{
                        NET_FW_PROFILE2_ = $_
                        BlockAllInboundTraffic = $fwPolicy2.BlockAllInboundTraffic($_)
                    } | Select-Object NET_FW_PROFILE2_, BlockAllInboundTraffic
                }
                $ret += [Int]$fwPolicy2.BlockAllInboundTraffic($_)
            }
            New-Object -TypeName PSObject -Property @{
                NET_FW_PROFILE2_ = 2147483647
                BlockAllInboundTraffic = [bool]($ret -eq 3)
            } | Select-Object NET_FW_PROFILE2_, BlockAllInboundTraffic
        }
        else
        {
            New-Object -TypeName PSObject -Property @{
                NET_FW_PROFILE2_ = $ProfileType
                BlockAllInboundTraffic = $fwPolicy2.BlockAllInboundTraffic($ProfileType)
            } | Select-Object NET_FW_PROFILE2_, BlockAllInboundTraffic
        }
    }
}