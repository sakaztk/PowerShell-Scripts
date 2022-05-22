<#
.SYNOPSIS
    指定されたファイルに現在のポリシーをエクスポートします。
#>
function Export-FwPolicy {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [String]$Path
    )
    $ret = Invoke-Command { netsh advfirewall export $Path }
    if ($LASTEXITCODE -eq 0) {
        $status = 'OK'
    }
    else {
        $status = 'NG'
    }
    New-Object -TypeName PSObject -Property @{ Status = $status; Output = $ret[0]} | Format-Table -AutoSize -Property Status, Output
}