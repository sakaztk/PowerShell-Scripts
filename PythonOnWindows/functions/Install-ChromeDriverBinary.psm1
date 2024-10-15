function Install-ChromeDriverBinary {
    [CmdletBinding()]
    Param (
        [String]$PipCommand = 'pip',
        [Switch]$Older114
    )
    $chromeVer = (Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe').'(Default)').VersionInfo.ProductVersion
    $chromeBuild = $chromeVer -replace '(\d*\.\d*\.\d*)\..*','$1'
    if($Older114) {
        $content = Invoke-WebRequest -uri "https://chromedriver.chromium.org/downloads" -UseBasicParsing
        $driverLatestUri = ($content.links.href | Select-String -Pattern "path=$chromeBuild" | Get-Unique | Sort-Object -Descending)[0]
        $driverVer = $driverLatestUri -replace ".*($chromeBuild.\d*).*",'$1'    
    }
    else {
        $content = Invoke-WebRequest -uri "https://googlechromelabs.github.io/chrome-for-testing/known-good-versions.json" -UseBasicParsing
        $json = ConvertFrom-Json $content.Content
        $driverVer = $json.versions.version | Where-Object { $_ -like "$chromeBuild*" } | Select-Object -Last 1
    }
    Write-Verbose "Current Chrome Version: $chromeVer"
    Write-Verbose "Download Driver Version: $driverVer"
    Write-Verbose "Invoking Command: $PipCommand install chromedriver-binary==$driverVer"
    . $PipCommand install chromedriver-binary==$driverVer
}