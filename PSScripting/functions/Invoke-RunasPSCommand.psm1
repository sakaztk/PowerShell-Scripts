function Invoke-RunasPSCommand {
    param (

        [String]$command = $(Get-ExecutionPolicy)
    )
    Process {
        $outFile = New-TemporaryFile
        $pinfo = New-Object System.Diagnostics.ProcessStartInfo
        $pinfo.FileName = "powershell.exe"
        $pinfo.Verb = "runas"
        $pinfo.UseShellExecute = $true
        $pinfo.Arguments = '-ExecutionPolicy Bypass -NoProfile -NonInteractive -Command "& {' + $command + ' | Out-File ' + $outFile + '}"'
        $p = New-Object System.Diagnostics.Process
        $p.StartInfo = $pinfo
        $p.Start() | Out-Null
        $p.WaitForExit()
        Get-Content $outFile
        Remove-Item $outfile
    }
}