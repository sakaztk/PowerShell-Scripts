function Set-TaskbarPenMenu {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline,Position=0)]
        [ValidateSet('Off', 'On')]
        [String]$State
    )
    Begin {
        $key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\PenWorkspace'
    }
    Process {
        switch ($State) {
            'Off' {$value = 0}
            'On' {$value = 1}
        }
        Set-ItemProperty -Path $key -Name PenWorkspaceButtonDesiredVisibility -Value $value
    }
}