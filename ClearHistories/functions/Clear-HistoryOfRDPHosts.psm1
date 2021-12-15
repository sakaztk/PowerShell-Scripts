function Clear-HistoryOfRDPHosts
{
    Remove-Item -Path Registry::"HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Default"
}
