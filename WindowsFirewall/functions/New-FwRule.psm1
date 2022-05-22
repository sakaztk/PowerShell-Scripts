#New-NetFirewallRule
function New-FwRule {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)][Int]$Action,
        [Parameter(Mandatory=$true)][String]$Name,
        [ValidateSet(1,2,4,2147483647)][Int]$Profiles = 2147483647,
        [ValidateSet(1,2,6,17,41,43,44,47,58,59,60,112,113,115,256)][Int]$Protocol = 256,
        [ValidateRange(0,2)][Int]$Direction = 1,
        $Interfaces,
        [String]$InterfaceTypes = 'All',
        [String]$LocalAddresses = '*',
        [String]$RemoteAddresses = '*',
        [String]$ApplicationName = '',
        [String]$ServiceName = '',
        [String]$Grouping = '',
        [String]$Description= '',
        [String]$LocalPorts= '',
        [String]$RemotePorts= '',
        [String]$IcmpTypesAndCodes = '',
        [Int]$EdgeTraversalOptions,
        [bool]$EdgeTraversal = $false,
        [bool]$Enabled = $false,
        [Switch]$Overwrite = $false
        
    )
    Begin {
        $fwPolicy2 = New-Object -ComObject HNetCfg.FwPolicy2
        $fwRule = New-Object -ComObject HNetCfg.FwRule
    }
    Process {
        $fwRule.Action = $Action
        $fwRule.Name= $Name
        $fwRule.Profiles = $Profiles
        $fwRule.Protocol = $Protocol
        $fwRule.Direction = $Direction
        $fwRule.Interfaces = $Interfaces
        $fwRule.InterfaceTypes = $InterfaceTypes
        $fwRule.LocalAddresses = $LocalAddresses
        $fwRule.RemoteAddresses = $RemoteAddresses
        if ($ApplicationName -ne '') {
            $fwRule.ApplicationName = $ApplicationName
        }
        if ($ServiceName -ne '') {
            $fwRule.ServiceName = $ServiceName
        }
        if ($Grouping -ne '') {
            $fwRule.Grouping = $Grouping
        }
        if ($Description -ne '') {
            $fwRule.Grouping = $Description
        }
        if ((($Protocol -eq 6) -or ($Protocol -eq 17)) -and ($LocalPorts -ne '')) {
            $fwRule.LocalPorts = $LocalPorts
        }
        if ((($Protocol -eq 6) -or ($Protocol -eq 17)) -and ($RemotePorts -ne '')) {
            $fwRule.RemotePorts = $RemotePorts
        }
        if ((($Protocol -eq 1) -or ($Protocol -eq 58)) -and ($IcmpTypesAndCodes -ne '')) {
            $fwRule.IcmpTypesAndCodes = $IcmpTypesAndCodes
        }
        $fwRule.EdgeTraversalOptions = $EdgeTraversalOptions
        $fwRule.EdgeTraversal = $EdgeTraversal
        $fwRule.Enabled = $Enabled
        if ($Overwrite) {
            $fwPolicy2.Rules.Remove($fwRule.Name)
        }
        $fwPolicy2.Rules.Add($fwRule)
    }
}