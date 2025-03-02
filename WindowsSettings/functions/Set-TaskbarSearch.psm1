function Set-TaskbarSearch {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline,Position=0)]
        [ValidateSet('Hide', 'Icon', 'Box')]
        [String]$Mode
    )
    Begin {
        $key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search'
    }
    Process {
        switch ($Mode) {
            'Hide' {$value = 0}
            'Icon' {$value = 1}
            'Box' {$value = 2}
        }
        Set-ItemProperty -Path $key -Name SearchboxTaskbarMode -Value $value
    }
}