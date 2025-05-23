function Restore-FwDefaults {
    try {
        (New-Object -ComObject HNetCfg.FwPolicy2).RestoreLocalFirewallDefaults()
        $status = 'OK'
    }
    catch {
        $status = 'NG'
    }
    New-Object -TypeName PSObject -Property @{ Status = $status }
}