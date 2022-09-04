#https://www.python.org/
#https://docs.python.org/3/using/windows.html
function Install-PythonForWindows {
    [CmdletBinding(DefaultParameterSetName='pythonorg-passive')]
    Param(
        [Parameter(ParameterSetName="winget")]
        [Switch]$winget,
        [Parameter(ParameterSetName="Chocolatey")]
        [Switch]$Chocolatey,
        [Parameter(ParameterSetName="pythonorg-passive")]
        [ValidateSet('2.7','3.6','3.7','3.8','3.9','3.10')]
        [String]$Version = '3.9',
        [Parameter(ParameterSetName="pythonorg-passive")]
        [Switch]$CompileAll,
        [Parameter(ParameterSetName="pythonorg-passive")]
        [Switch]$PrependPath,
        [Parameter(ParameterSetName="pythonorg-passive")]
        [Switch]$IncludeDebug,
        [Parameter(ParameterSetName="pythonorg-passive")]
        [Switch]$IncludeSymbols,
        [Parameter(ParameterSetName="pythonorg-passive")]
        [Switch]$NoAssociateFiles,
        [Parameter(ParameterSetName="pythonorg-passive")]
        [Switch]$NoShortcuts,
        [Parameter(ParameterSetName="pythonorg-passive")]
        [Switch]$NoIncludeDoc,
        [Parameter(ParameterSetName="pythonorg-passive")]
        [Switch]$NoIncludeDev,
        [Parameter(ParameterSetName="pythonorg-passive")]
        [Switch]$NoIncludeExe,
        [Parameter(ParameterSetName="pythonorg-passive")]
        [Switch]$NoIncludeLauncher,
        [Parameter(ParameterSetName="pythonorg-passive")]
        [Switch]$NoInstallLauncherAllUsers,
        [Parameter(ParameterSetName="pythonorg-passive")]
        [Switch]$NoIncludeLib,
        [Parameter(ParameterSetName="pythonorg-passive")]
        [Switch]$NoIncludePip,
        [Parameter(ParameterSetName="pythonorg-passive")]
        [Switch]$NoIncludeTcltk,
        [Parameter(ParameterSetName="pythonorg-passive")]
        [Switch]$NoIncludeTest,
        [Parameter(ParameterSetName="pythonorg-passive")]
        [Switch]$NoIncludeTools,
        [Parameter(ParameterSetName="pythonorg-passive")]
        [Switch]$LauncherOnly,
        [Parameter(ParameterSetName="pythonorg-passive")]
        [Switch]$SimpleInstall,
        [Parameter(ParameterSetName="pythonorg-passive")]
        [Switch]$InstallAllUsers,
        [Parameter(ParameterSetName="pythonorg-passive")]
        [String]$SimpleInstallDescription = '',
        [Parameter(Mandatory = $true, ParameterSetName="pythonorg-specific")]
        [String]$Opttions,
        [Parameter(ParameterSetName="pythonorg-passive")]
        [Parameter(ParameterSetName="pythonorg-specific")]
        [String]$WorkingFolder = (Get-Location).Path
    )
    $ErrorActionPreference = 'Stop'
    if ((-not($winget)) -and (-not($Chocolatey)) ) {
        if ($Opttions) {
            $installOpt = $Opttions
        }
        else {
            $installOpt = '/passive'
            if ($CompileAll) {$installOpt += " CompileAll=$([int][bool]$CompileAll)"}
            if ($PrependPath) {$installOpt += " PrependPath=$([int][bool]$PrependPath)"}
            if ($IncludeDebug) {$installOpt += " Include_debug=$([int][bool]$IncludeDebug)"}
            if ($IncludeSymbols) {$installOpt += " Include_symbols=$([int][bool]$IncludeSymbols)"}
            if ($InstallAllUsers) {$installOpt += " InstallAllUsers=$([int][bool]$InstallAllUsers)"}
            if ($NoAssociateFiles) {$installOpt += " AssociateFiles=$([int]-not([bool]$NoAssociateFiles))"}
            if ($NoShortcuts) {$installOpt += " Shortcuts=$([int]-not([bool]$NoShortcuts))"}
            if ($NoIncludeDoc) {$installOpt += " Include_doc=$([int]-not([bool]$NoIncludeDoc))"}
            if ($NoIncludeDev) {$installOpt += " Include_dev=$([int]-not([bool]$NoIncludeDev))"}
            if ($NoIncludeExe) {$installOpt += " Include_exe=$([int]-not([bool]$NoIncludeExe))"}
            if ($NoIncludeLauncher) {$installOpt += " Include_launcher=$([int]-not([bool]$NoIncludeLauncher))"}
            if ($NoInstallLauncherAllUsers) {$installOpt += " InstallLauncherAllUsers=$([int]-not([bool]$NoInstallLauncherAllUsers))"}
            if ($NoIncludeLib) {$installOpt += " Include_lib=$([int]-not([bool]$NoIncludeLib))"}
            if ($NoIncludePip) {$installOpt += " Include_pip=$([int]-not([bool]$NoIncludePip))"}
            if ($NoIncludeTcltk) {$installOpt += " Include_tcltk=$([int]-not([bool]$NoIncludeTcltk))"}
            if ($NoIncludeTest) {$installOpt += " Include_test=$([int]-not([bool]$NoIncludeTest))"}
            if ($NoIncludeTools) {$installOpt += " Include_tools=$([int]-not([bool]$NoIncludeTools))"}
            if ($LauncherOnly) {$installOpt += " LauncherOnly=$([int][bool]$LauncherOnly)"}
            if ($SimpleInstall) {$installOpt += " SimpleInstall=$([int][bool]$SimpleInstall)"}
            if (-not('' -eq $SimpleInstallDescription)) {$installOpt += " SimpleInstallDescription=$($SimpleInstallDescription)"}
        }
        $links = (Invoke-WebRequest -uri 'https://www.python.org/downloads/windows/' -UseBasicParsing).Links.href
        $targetLinks = $links | Select-String -Pattern ".*python-($Version\.\d*)-amd64.exe"
        $latestVer = $Version + '.' + ($targetLinks -replace ".*python-$Version\.(\d*)-amd64.exe", '$1'| Measure-Object -Maximum).Maximum
        $fileUri = ($targetLinks | Select-String -Pattern ".*python-$latestVer-amd64.exe" | Get-Unique).Tostring().Trim()
        $filePath = Join-Path $WorkingFolder ('python' + (Get-Date).ToString("yyyyMMddHHmmss") + (Get-Random) + '.exe')
        Write-Verbose "Download from $fileUri"
        Write-Verbose "Downloading latest Python $Version for Windows..."
        $progressPreference = 'SilentlyContinue'
        Invoke-WebRequest -uri $fileUri -UseBasicParsing -OutFile $filePath
        $progressPreference = 'Continue'
        Write-Verbose "Installation Options: $installOpt"
        Write-Verbose 'Installing Python...'
        Start-Process -FilePath $filePath -ArgumentList $installOpt -Wait
        Start-Sleep -Seconds 5
        Remove-Item $filePath -Force
    }
    elseif ($winget) {
            if ($null -eq (Invoke-Command -ScriptBlock {$ErrorActionPreference="silentlycontinue"; winget -v} -ErrorAction SilentlyContinue)) {
                throw 'winget not found.'
            }
            Start-Process -FilePath 'winget' -ArgumentList ('install -h Python.Python.3') -NoNewWindow -wait
    }
    elseif ($Chocolatey) {
        if ($null -eq (Invoke-Command -ScriptBlock {$ErrorActionPreference="silentlycontinue"; chocolatey version} -ErrorAction SilentlyContinue)) {
            throw 'Chocolatey not found.'
        }
        Start-Process -FilePath 'choco' -ArgumentList ('install -y git') -NoNewWindow -wait
    }
}