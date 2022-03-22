function Invoke-DiskCleanup {
    Param (
        [Switch]$ActiveSetupTempFolders,
        [Switch]$BranchCache,
        [Switch]$ContentIndexerCleaner,
        [Switch]$D3DShaderCache,
        [Switch]$DeliveryOptimizationFiles,
        [Switch]$DeviceDriverPackages,
        [Switch]$DiagnosticDataViewerDatabaseFiles,
        [Switch]$DownloadedProgramFiles,
        [Switch]$DownloadsFolder,
        [Switch]$FeedbackHubArchiveLogFiles,
        [Switch]$InternetCacheFiles,
        [Switch]$LanguagePack,
        [Switch]$OfflinePagesFiles,
        [Switch]$OldChkDskFiles,
        [Switch]$PreviousInstallations,
        [Switch]$RecycleBin,
        [Switch]$RetailDemoOfflineContent,
        [Switch]$SetupLogFiles,
        [Switch]$SystemErrorMemoryDumpFiles,
        [Switch]$SystemErrorMinidumpFiles,
        [Switch]$TemporaryFiles,
        [Switch]$TemporarySetupFiles,
        [Switch]$TemporarySyncFiles,
        [Switch]$ThumbnailCache,
        [Switch]$UpdateCleanup,
        [Switch]$UpgradeDiscardedFiles,
        [Switch]$UserFileVersions,
        [Switch]$WindowsDefender,
        [Switch]$WindowsErrorReportingFiles,
        [Switch]$WindowsESDInstallationFiles,
        [Switch]$WindowsUpgradeLogFiles
    )
    Begin {
        $basePath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches'
    }
    Process {
        $targets = @()
        if ($ActiveSetupTempFolders) { $targets += 'Active Setup Temp Folders' }
        if ($BranchCache) { $targets += 'BranchCache' }
        if ($ContentIndexerCleaner) { $targets += 'Content Indexer Cleaner' }
        if ($D3DShaderCache) { $targets += 'D3D Shader Cache' }
        if ($DeliveryOptimizationFiles) { $targets += 'Delivery Optimization Files' }
        if ($DeviceDriverPackages) { $targets += 'Device Driver Packages' }
        if ($DiagnosticDataViewerDatabaseFiles) { $targets += 'Diagnostic Data Viewer database files' }
        if ($DownloadedProgramFiles) { $targets += 'Downloaded Program Files' }
        if ($DownloadsFolder) { $targets += 'DownloadsFolder' }
        if ($FeedbackHubArchiveLogFiles) { $targets += 'Feedback Hub Archive log files' }
        if ($InternetCacheFiles) { $targets += 'Internet Cache Files' }
        if ($LanguagePack) { $targets += 'Language Pack' }
        if ($OfflinePagesFiles) { $targets += 'Offline Pages Files' }
        if ($OldChkDskFiles) { $targets += 'Old ChkDsk Files' }
        if ($PreviousInstallations) { $targets += 'Previous Installations' }
        if ($RecycleBin) { $targets += 'Recycle Bin' }
        if ($RetailDemoOfflineContent) { $targets += 'RetailDemo Offline Content' }
        if ($SetupLogFiles) { $targets += 'Setup Log Files' }
        if ($SystemErrorMemoryDumpFiles) { $targets += 'System error memory dump files' }
        if ($SystemErrorMinidumpFiles) { $targets += 'System error minidump files' }
        if ($TemporaryFiles) { $targets += 'Temporary Files' }
        if ($TemporarySetupFiles) { $targets += 'Temporary Setup Files' }
        if ($TemporarySyncFiles) { $targets += 'Temporary Sync Files' }
        if ($ThumbnailCache) { $targets += 'Thumbnail Cache' }
        if ($UpdateCleanup) { $targets += 'Update Cleanup' }
        if ($UpgradeDiscardedFiles) { $targets += 'Upgrade Discarded Files' }
        if ($UserFileVersions) { $targets += 'User file versions' }
        if ($WindowsDefender) { $targets += 'Windows Defender' }
        if ($WindowsErrorReportingFiles) { $targets += 'Windows Error Reporting Files' }
        if ($WindowsESDInstallationFiles) { $targets += 'Windows ESD installation files' }
        if ($WindowsUpgradeLogFiles) { $targets += 'Windows Upgrade Log Files' }

        foreach($i in 1..9999) {
            $found = $false
            (Get-ChildItem $basePath).PSPath | Foreach-Object {
                if ($null -ne (Get-ItemProperty $($_))."StateFlags$('{0:D4}' -f $i)") {
                    $found = $true
                    continue
                }
            }
            if (-not($found)) {
                (Get-ChildItem $basePath).PSChildName | Foreach-Object {
                    if ($_ -in $targets) {
                        $value = 2
                    }
                    else {
                        $value = 0
                    }
                    New-ItemProperty (Join-Path $basePath $_) -PropertyType 'DWORD' -Name "StateFlags$('{0:D4}' -f $i)" -Value $value -Force | Out-Null
                }
                Start-Process cleanmgr.exe -ArgumentList "/SAGERUN:$i" -Wait
                (Get-ChildItem $basePath).PSChildName | Foreach-Object {
                    Remove-ItemProperty (Join-Path $basePath $_) -Name "StateFlags$('{0:D4}' -f $i)" -Force
                }
                break
            }
        }
    }
}
