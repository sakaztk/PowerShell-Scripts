function Set-TaskbarAlignment {
    param (
        [Parameter(Mandatory,ValueFromPipeline,Position=0)]
        [ValidateSet('Left', 'Center')]
        [String]$Mode
    )
    Begin {
        $key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    }
    Process {
        switch ($Mode) {
            "Left" {$value = 0}
            "Center" {$value = 1}
        }
        Set-ItemProperty -Path $key -Name TaskbarAl -Value $value
    }
}