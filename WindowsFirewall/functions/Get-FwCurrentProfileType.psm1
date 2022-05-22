#(Get-NetConnectionProfile).NetworkCategory
<#
.SYNOPSIS
    現在のプロファイルタイプを取得します。
 .OUTPUTS
    このコマンドレットは、現在のファイアウォールのプロファイルタイプを表す NET_FW_PROFILE_TYPE2_ (Int32) の値を返します。
#>
function Get-FwCurrentProfileType {
    (New-Object -ComObject HNetCfg.FwPolicy2).CurrentProfileTypes
}