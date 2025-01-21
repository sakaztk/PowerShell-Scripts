function Start-LgpoExeDownload {
    [CmdletBinding()]
    param (
        $Uri = 'https://download.microsoft.com/download/8/5/C/85C25433-A1B0-4FFA-9429-7E023E7DA8D8/LGPO.zip',
        $OutFile = 'LGPO.zip',
        $Destination = (Join-Path $env:WINDIR 'System32'),
        $WorkingFolder = $env:TEMP,
        [Switch]$NoCleanup
    )
    Write-Verbose "Downloading... (Destination: $Destination)"
    Invoke-WebRequest -Uri $Uri -OutFile $OutFile -Verbose:$VerbosePreference
    Expand-Archive -Path $OutFile -DestinationPath $WorkingFolder -Force -Verbose:$VerbosePreference
    Copy-Item -Path (Join-Path $WorkingFolder 'LGPO_30\LGPO.exe') -Destination $Destination -Force -Verbose:$VerbosePreference
    if (-not($NoCleanup)) {
        Write-Verbose 'Cleaning up...'
        Remove-Item $OutFile -Verbose:$VerbosePreference
        Remove-Item (Join-Path $WorkingFolder 'LGPO_30') -Recurse -Force -Verbose:$VerbosePreference
    }
}