
function Install-W10WheelNet {
    [CmdletBinding()]
    Param(
        [String]$WorkingFolder = (Get-Location).Path,
        [String]$InstallationPath = 'C:\Local\Softwares\w10wheel.net'
    )
    Push-Location $WorkingFolder
    Write-Verbose 'Downloading latest W10Wheel.net...'
    $releaseURI = 'https://github.com/ykon/w10wheel.net/releases'
    $installer = 'w10wheelnet.zip'
    $latestRelease = (Invoke-WebRequest -Uri "$releaseURI/latest" -UseBasicParsing -Headers @{'Accept'='application/json'}| ConvertFrom-Json).update_url
    $versionString = $latestRelease -replace '.*tag/(.*)', '$1'
    $links = (Invoke-WebRequest -Uri "$releaseURI/expanded_assets/$($versionString)" -UseBasicParsing).Links.href
    $fileUri = 'https://github.com' + ($links | Select-String -Pattern '.*download.*\.zip' | Get-Unique).Tostring().Trim()
    Write-Verbose "Downloading from $fileUri"
    $currentPP = $progressPreference
    $progressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $fileUri -UseBasicParsing -OutFile (Join-Path $WorkingFolder $installer) -Verbose
    $progressPreference = $currentPP
    Write-Verbose 'Installing latest W10Wheel.net...'
    if (-not(Test-Path $InstallationPath)) {
        New-Item $InstallationPath -ItemType Directory | Out-Null
    }
    Expand-Archive -Path (Join-Path $WorkingFolder $installer) -DestinationPath $InstallationPath -Force
    [Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem') > $null
    $zipFile = [IO.Compression.ZipFile]::OpenRead("$(Join-Path $WorkingFolder $installer)")
    $appFolder = $zipFile.Entries[0].FullName -replace('/','')
    $zipFile.Dispose()
    $latestPath = join-path $InstallationPath 'Latest'
    if (Test-Path $latestPath) {
        #Remove-Item $latestPath -Force -Confirm:$False
        [io.directory]::Delete($latestPath)
    }
    if (([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        New-Item -ItemType SymbolicLink -Path $latestPath -Target (join-path $InstallationPath $appFolder) -Force
    }
    else {
        Start-Process -FilePath cmd.exe -ArgumentList '/c mklink /j', $latestPath, (join-path $InstallationPath $appFolder)
    }
    Remove-Item -Path (Join-Path $WorkingFolder $installer) -Force
    Pop-Location
}