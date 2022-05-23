function Invoke-SelfElevate {
    param (
        [ValidateSet(
            'AllSigned',
            'Bypass',
            'Default',
            'RemoteSigned',
            'Restricted',
            'Undefined',
            'Unrestricted'
        )]
        [String]$ExecutionPolicy = $(Get-ExecutionPolicy)
    )
    Process {
        $myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
        $myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID) 
        $adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator
        if (-not($myWindowsPrincipal.IsInRole($adminRole))) {
            $newProcess = New-Object Diagnostics.ProcessStartInfo 'powershell.exe'
            $newProcess.Arguments = '-ExecutionPolicy ' + $ExecutionPolicy `
                                + ' -File "' ` + $script:MyInvocation.MyCommand.Path + '"'
            $newProcess.Verb = 'runas'
            [System.Diagnostics.Process]::Start($newProcess);
            exit
        }
    }
}