#Get-NetFirewallProfile -Name
#((Get-NetConnectionProfile).NetworkCategory|ForEach-Object{if($_ -eq 'DomainAuthenticated'){'Domain'}else{$_}}|ForEach-Object{Get-NetFirewallProfile -Name $_}).Enabled

<#
.SYNOPSIS
    Windows Firewallが有効である事を確認します。
 
.PARAMETER ProfileType
    対象プロファイルを NET_FW_PROFILE2_ の値で指定します。省略時はカレントプロファイルを確認します。
    NET_FW_PROFILE2_DOMAIN = 1
    NET_FW_PROFILE2_PRIVATE = 2
    NET_FW_PROFILE2_PUBLIC = 4
 
 .INPUTS
    パイプを使用して、確認するプロファイルを Test-FwEnabled に渡すことができます。
 
 .OUTPUTS
    このコマンドレットは、ファイアウォールが有効な場合は "True" を返し、そうでない場合は "False" を返します。
 
.EXAMPLE
    Test-FwEnabled (NET_FW_PROFILE_TYPE2).NET_FW_PROFILE2_DOMAIN
    Domainプロファイルが有効か確認します。
#>
function Test-FwEnabled {
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline=$true)]
        [ValidateSet(1,2,3,4,5,6,7,2147483647)]
        [Int]$ProfileType = 0,
        [Switch]$Details
    )
    Begin {
        $fwPolicy2 = New-Object -ComObject HNetCfg.FwPolicy2
        If ($ProfileType -eq 0) { $ProfileType = $fwPolicy2.CurrentProfileTypes }
    }
    Process {
        $targetProfiles = @();
        if ($ProfileType -eq 2147483647) {
            $targetProfiles = 1, 2, 4
        }
        else {
            $i = $ProfileType
            do {
                if ($i -ge 4) {
                    $targetProfiles += 4
                    $i -= 4
                }
                elseif ($i -ge 2) {
                    $targetProfiles += 2
                    $i -= 2
                }
                elseif ($i -ge 1) {
                    $targetProfiles += 1
                    $i -= 1
                }
            }
            until ($i -le 0)
        }
        if ($Details) {
            $targetProfiles | ForEach-Object {
                (New-Object -TypeName PSObject -Property @{
                    ProfileType = [NET_FW_PROFILE_TYPE2_]$_
                    FirewallEnabled = $fwPolicy2.FirewallEnabled($_)
                } | Select-Object ProfileType, FirewallEnabled)
            }
        }
        else {
            $targetProfiles | Sort-Object | ForEach-Object {
                if ($fwPolicy2.FirewallEnabled($_))
                {
                    return $true
                }
                else
                {
                    return $false
                }
            }
        }
    }
}