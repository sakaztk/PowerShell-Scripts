function Install-EdgeWebDriver {
    [CmdletBinding()]
    Param (
        [String]$OS = 'win64',
        [ValidateScript({
            if(-Not ($_ | Test-Path -PathType Container) ){
                throw "Folder does not exist." 
            }
            return $true
        })]
        [System.IO.FileInfo]$DownloadFolder="."
    )
    $exProgressPreference = $ProgressPreference
    $ProgressPreference = 'SilentlyContinue'
    $edgeVer = (Get-ItemProperty -Path HKCU:\Software\Microsoft\Edge\BLBeacon -Name version).version
    $edgeBuild = $edgeVer -replace '(\d*)\..*','$1'
    $content = Invoke-WebRequest -uri 'https://developer.microsoft.com/en-us/microsoft-edge/tools/webdriver' -UseBasicParsing
    $driverLatestUri = ($content.links.href | Select-String -Pattern "$edgeBuild.*$os" | Get-Unique | Sort-Object -Descending)[0]
    $driverVer = $driverLatestUri -replace '.*/([0-9]+(\.[0-9]+)+)/.*','$1'
    Write-Verbose "Current Edge Version: $edgeVer"
    Write-Verbose "Download Driver Version: $driverVer"
    if($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent) {
        $passThru=$true
    }
    else {
        $passThru=$false
    }
    $downloadParams = @{
        Uri = [String]$driverLatestUri
        OutFile = Join-Path $DownloadFolder 'edgedriver.zip'
        UseBasicParsing = $true
        PassThru = $passThru
    }
    Write-Verbose "Downloading $driverLatestUri..."
    try {
        Invoke-WebRequest @downloadParams  
    }
    catch {
        throw
    }
    finally {
        $ProgressPreference = $exProgressPreference
    }
    Write-Verbose "Unzipping File..."
    Add-Type -Assembly System.IO.Compression.FileSystem
    $zipFile = [IO.Compression.ZipFile]::OpenRead('edgedriver.zip')
    $zipFile.Entries | Where-Object {$_.Name -like '*.exe'} | ForEach-Object {
        [System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, $_.Name, $true)
    }
    $zipFile.Dispose()
    Remove-Item 'edgedriver.zip'
    if($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent) {
        Invoke-Expression "$(Join-Path $DownloadFolder 'msedgedriver.exe') --version"
    }
}