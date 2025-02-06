function Set-TaskbarWidgetsButton {
    param (
        [Parameter(Mandatory,ValueFromPipeline,Position=0)]
        [ValidateSet('Hide', 'Show')]
        [String]$State
    )
    Begin {
        $key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    }
    Process {
        switch ($State) {
            "Hide" {$value = 0}
            "Show" {$value = 1}
        }
        Set-ItemProperty -Path $key -Name TaskbarDa -Value $value
    }
}