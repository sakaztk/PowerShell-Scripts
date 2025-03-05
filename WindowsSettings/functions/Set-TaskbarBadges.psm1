function Set-TaskbarBadges {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline,Position=0)]
        [ValidateSet('Off', 'On')]
        [String]$State
    )
    Begin {
        $key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    }
    Process {
        switch ($State) {
            'Off' {$value = 0}
            'On' {$value = 1}
        }
        Set-ItemProperty -Path $key -Name TaskbarBadges -Value $value
    }
}