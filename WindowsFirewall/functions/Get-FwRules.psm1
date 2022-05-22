#Get-NetFirewallRule
function Get-FwRules
{
    (New-Object -ComObject HNetCfg.FwPolicy2).Rules
}