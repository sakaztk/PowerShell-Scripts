function Install-ChromeDriverBinary {
    $chromeVer = (Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe').'(Default)').VersionInfo.ProductVersion
    $chromeBuild = $chromeVer -replace '(\d*\.\d*\.\d*)\..*','$1'
    $content = Invoke-WebRequest -uri "https://chromedriver.chromium.org/downloads" -UseBasicParsing
    $driverLatestUri = ($content.links.href | Select-String -Pattern "path=$chromeBuild" | Get-Unique | Sort-Object -Descending)[0]
    $driverVer = $driverLatestUri -replace ".*($chromeBuild.\d*).*",'$1'
    pip install chromedriver-binary==$driverVer
}
