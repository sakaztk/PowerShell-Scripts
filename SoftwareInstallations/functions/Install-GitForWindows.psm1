function Install-GitForWindows {
    [CmdletBinding()]
    Param(
        [ValidateSet('GitHub','winget','Chocolatey')]
        [String]$By = 'GitHub',
        [String]$InstallerOpttion = '/SILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /COMPONENTS="icons,ext\reg\shellhere,assoc,assoc_sh"',
        [String]$WorkingFolder = (Get-Location).Path
        )
    $ErrorActionPreference = 'Stop'

    switch ( $By ) {
        'GitHub' {
            Write-Verbose 'Downloading latest Git for Windows...'
            $latestRelease = (Invoke-WebRequest -Uri 'https://github.com/git-for-windows/git/releases/latest' -UseBasicParsing -Headers @{'Accept'='application/json'}| ConvertFrom-Json).update_url
            $links = (Invoke-WebRequest -Uri "https://github.com$($latestRelease)" -UseBasicParsing).Links.href
            $fileUri = 'https://github.com' + ( $links | Select-String -Pattern '.*64-bit.exe' | Get-Unique).Tostring().Trim()
            $fileName = 'git' + (Get-Date).ToString("yyyyMMddHHmmss") + (Get-Random) + '.exe'
            Write-Verbose "Download from $fileUri"
            $progressPreference = 'SilentlyContinue'
            Invoke-WebRequest -Uri $fileUri -UseBasicParsing  -OutFile (Join-Path $WorkingFolder $fileName)
            $progressPreference = 'Continue'
            Write-Verbose 'Installing latest Git for Windows...'
            Start-Process -FilePath (Join-Path $WorkingFolder $fileName) -ArgumentList ($InstallerOpttion) -wait
            Start-Sleep -Seconds 5
            Remove-Item (Join-Path $WorkingFolder $fileName) -Force
        }
        'winget' {
            Start-Process -FilePath 'winget' -ArgumentList ('install -h Git.Git') -NoNewWindow -wait
        }
        'Chocolatey' {
            Start-Process -FilePath 'choco' -ArgumentList ('install -y git') -NoNewWindow -wait
        }
    }
}