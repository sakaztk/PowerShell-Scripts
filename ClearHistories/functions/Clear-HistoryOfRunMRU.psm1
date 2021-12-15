function Clear-HistoryOfRunMRU
{
    Remove-Item -Path Registry::"HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU"
}
