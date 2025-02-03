function Set-ColorMode {
    param (
        [Parameter(Mandatory,ValueFromPipeline,Position=0)]
        [ValidateSet('Light', 'Dark')]
        [String]$Mode
    )
    Begin {
        $key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize'
    }
    Process {
        switch ($Mode) {
            "Dark" {$value = 0}
            "Light" {$value = 1}
        }
        Set-ItemProperty -Path $key -Name SystemUsesLightTheme -Value $value
        Set-ItemProperty -Path $key -Name AppsUseLightTheme -Value $value
    }
}