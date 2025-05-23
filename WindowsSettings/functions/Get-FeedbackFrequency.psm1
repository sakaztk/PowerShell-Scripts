function Get-FeedbackFrequency {
    param (
        [ValidateSet('CurrentUser', 'UserDefault')]
        $Target = 'CurrentUser'
    )
    Begin {
        $keyPath = 'SOFTWARE\Microsoft\Siuf\Rules'
        if ($Target -contains 'UserDefault') {
            REG LOAD HKLM\TempDefaultUser $Env:SystemDrive\Users\Default\NTUSER.DAT > $null
        }
    }
    Process {
        $Target | ForEach-Object {
            if ($_ -eq 'UserDefault') {
                $keyPath = Join-Path 'HKLM:\TempDefaultUser' $keyPath
            }
            elseif ($_ -eq 'CurrentUser') {
                $keyPath = Join-Path 'HKCU:' $keyPath
            }
            $pins = (Get-ItemProperty -Path $keyPath -ErrorAction SilentlyContinue).PeriodInNanoSeconds
            $nsip = (Get-ItemProperty -Path $keyPath -ErrorAction SilentlyContinue).NumberOfSIUFInPeriod
            if ( ($null -eq $pins) -And ($null -eq $nsip) ) {
                $status = 'Automatically'
            }
            elseif ( (100000000 -eq $pins) -And ($null -eq $nsip) ) {
                $status = 'Always'
            }
            elseif ( (864000000000 -eq $pins) -And (1 -eq $nsip) ) {
                $status = 'Daily'
            }
            elseif ( (6048000000000 -eq $pins) -And (1 -eq $nsip) ) {
                $status = 'Weekly'
            }
            elseif ( ($null -eq $pins) -And (0 -eq $nsip) ) {
                $status = 'Never'
            }
            New-Object -TypeName PSObject -Property @{
                Target = $_
                Status = $status
                PeriodInNanoSeconds = $pins
                NumberOfSIUFInPeriod = $nsip
            } | Select-Object Target, Status, PeriodInNanoSeconds, NumberOfSIUFInPeriod
        }
    }
    End {
        if ($Target -contains 'UserDefault') {
            REG UNLOAD HKLM\TempDefaultUser > $null
        }
    }
}