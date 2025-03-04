function Set-TaskbarAutoHide {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline,Position=0)]
        [ValidateSet('Off', 'On')]
        [String]$State
    )
    Begin {
        $key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3'
    }
    Process {
        switch ($State) {
            'Off' {$value = 0x02}
            'On' {$value = 0x03}
        }
        $settings = (Get-ItemProperty -Path $key).Settings
        $settings[8] = $value
        Set-ItemProperty -Path $key -Name Settings -Value $settings
        Stop-Process -Name 'explorer' -Force
    }
}