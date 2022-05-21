function Get-PowerSettingValue {
    Param (
        [Parameter(mandatory=$true)]
        [Alias('Plan')]
        [String]$PlanName,

        [Parameter(mandatory=$true)]
        [ValidateSet('AC','DC')]
        [Alias('Type','PowerType','SupplyType')]
        [String]$PowerSupplyType,

        [Parameter(mandatory=$true)]
        [Alias('Config','Setting','ConfigName')]
        [String]$SettingName
    )
    Process {
        if ($PlanName) {
            $planID = Get-PowerPlanIDFromName -Name $PlanName -Type GUID
        }
        $settingID = Get-PowerSettingIDFromName -Name $SettingName
        $targetID = 'Microsoft:PowerSettingDataIndex\' `
                    + $planID + '\' `
                    + $PowerSupplyType + '\' `
                    + $settingID
        $instance = Get-CimInstance Win32_PowerSettingDataIndex -Namespace root/CIMV2/power | Where-Object {$_.InstanceID -like $targetID}
        $instance.SettingIndexValue
    }
}