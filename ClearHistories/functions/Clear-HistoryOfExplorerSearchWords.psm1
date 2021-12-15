function Clear-HistoryOfExplorerSearchWords
{
    Remove-Item -Path Registry::"HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\WordWheelQuery"
}
