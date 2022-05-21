function Get-PowerSetting {
    Get-CimInstance -Class Win32_PowerSetting -Namespace root/CIMV2/power
}