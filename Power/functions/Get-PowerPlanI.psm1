function Get-PowerPlan {
    Get-CimInstance -Class Win32_PowerPlan -Namespace root/CIMV2/power
}