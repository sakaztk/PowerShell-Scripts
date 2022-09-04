<#
.SYNOPSIS
既存ネットワークの「ネットワークの場所」を設定。

.DESCRIPTION
Windows8.1 および Windows Server 2012 R2 からは Set-NetConnectionProfile/Get-NetConnectionProfile
コマンドレットによりコントロールが可能。

Set-NetConnectionProfile
https://technet.microsoft.com/library/jj899565.aspx

Get-NetConnectionProfile
https://technet.microsoft.com/en-us/library/jj899566.aspx

.PARAMETER Name
対象ネットワーク名を指定。Allパラメータが優先。

.PARAMETER All
すべてのネットワークを対象とする場合に指定。

.PARAMETER Type
「ネットワークの場所」を指定。設定値は Public または Private。

.PARAMETER IfOnlined
対象ネットワークがオンラインの場合のみ対象とする場合に指定。

.EXAMPLE
Set-NetworkCategory -All -Type Private
すべてのネットワークの場所を Private に設定

.EXAMPLE
Set-NetworkCategory -All -IfOnlined -Type Public
すべてのオンラインネットワークの場所を Public に設定。

.EXAMPLE
Set-NetworkCategory -Name 'Unidentified network' -Type Public
「Unidentified network」のネットワークの場所を Public に設定。

#>
function Set-NetworkCategory {
    [CmdletBinding()]
    Param (
        [String]$Name,
        [Parameter(mandatory=$true)][ValidateSet('Public','Private')][String]$Type,
        [Switch]$All,
        [Switch]$IfOnlined
    )
    Begin {
        $NLMType = [Type]::GetTypeFromCLSID('DCB00C01-570F-4A9B-8D69-199FDBA5723B')
        $INetworkListManager = [Activator]::CreateInstance($NLMType)

        $NLM_ENUM_NETWORK_CONNECTED  = 1
        $NLM_NETWORK_CATEGORY_PUBLIC = 0x00
        $NLM_NETWORK_CATEGORY_PRIVATE = 0x01
    }
    Process {
        $INetworks = $INetworkListManager.GetNetworks($NLM_ENUM_NETWORK_CONNECTED)
        
        foreach ($INetwork in $INetworks) {
            $NetworkName = $INetwork.GetName()
            $Category = $INetwork.GetCategory()

            switch ($Type) {
                'Public' {
                    $CategoryTo = $NLM_NETWORK_CATEGORY_PUBLIC
                }
                'Private' {
                    $CategoryTo = $NLM_NETWORK_CATEGORY_PRIVATE
                }
            }
            
            if (($IfOnlined -eq $True) -And ($All -eq $True)) {
                if ($INetwork.IsConnected) {
                    $INetwork.SetCategory($CategoryTo)
                }
            }
            elseif (($IfOnlined -eq $True) -And ($Name -eq $IsNull)) {
                if ($INetwork.IsConnected -and ($NetworkName -eq $Name)) {
                    $INetwork.SetCategory($CategoryTo)
                }
            }
            elseif ($All -eq $True) {
                $INetwork.SetCategory($CategoryTo)
            }
            elseif ($Name -eq $IsNull) {
                if ($NetworkName -eq $Name) {
                    $INetwork.SetCategory($CategoryTo)
                }
            }
        }
    }
}