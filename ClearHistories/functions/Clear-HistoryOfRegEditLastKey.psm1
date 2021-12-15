function Clear-HistoryOfRegEditLastKey
{
    Set-ItemProperty -Path Registry::"HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Regedit" -Name LastKey -Value ""
}
