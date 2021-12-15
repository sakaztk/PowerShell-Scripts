function Clear-HistoryOfPaintRecentFile
{
    Remove-Item -Path Registry::"HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Paint\Recent File List"
}
