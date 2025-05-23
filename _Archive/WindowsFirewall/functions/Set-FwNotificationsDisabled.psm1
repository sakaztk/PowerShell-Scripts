<#
.SYNOPSIS
    通知の無効化を設定します。
 
.PARAMETER ProfileType
    対象プロファイルを NET_FW_PROFILE2_ の値で指定します。省略時はカレントプロファイルを設定します。
    NET_FW_PROFILE2_DOMAIN = 1
    NET_FW_PROFILE2_PRIVATE = 2
    NET_FW_PROFILE2_PUBLIC = 4
 
 .INPUTS
    パイプを使用して、設定するプロファイルを Get-FwBlockAllInboundTraffic に渡すことができます。
#>
function Set-FwNotificationsDisabled {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$true)]
        [ValidateSet(1,2,4,2147483647)]
        [Int]$ProfileType,
        [Bool]$Disable,
        [Switch]$All
    )
    Begin {
        $fwPolicy2 = New-Object -ComObject HNetCfg.FwPolicy2
        if ($ProfileType -eq 0) { $ProfileType = $fwPolicy2.CurrentProfileTypes }
    }
    Process {
        if (($profileType -eq 2147483647) -or $All) {
            $target = @(1,2,4)
        }
        else {
            $target = @($ProfileType)
        }
        $target | ForEach-Object {
            $fwPolicy2.NotificationsDisabled($_) = $Disable
            New-Object -TypeName PSObject -Property @{
                NET_FW_PROFILE2_ = $_
                NotificationsDisabled = $fwPolicy2.NotificationsDisabled($_)
            } | Select-Object NET_FW_PROFILE2_, NotificationsDisabled
        }
    }
}