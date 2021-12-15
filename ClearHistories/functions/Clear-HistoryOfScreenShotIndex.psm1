function Clear-HistoryOfScreenShotIndex
{
    Set-ItemProperty -Path Registry::"HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name ScreenShotIndex -Value 1
}
