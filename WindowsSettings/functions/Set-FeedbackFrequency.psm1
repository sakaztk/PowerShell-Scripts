function Set-FeedbackFrequency {
    param (
        [ValidateSet('CurrentUser', 'UserDefault')]
        $Target = 'CurrentUser',
        [Parameter(Mandatory=$True)]
        [ValidateSet('Automatically', 'Always', 'Daily', 'Weekly', 'Never')]
        [String]$Value
    )
    Begin {
        $keyPath = 'SOFTWARE\Microsoft\Siuf\Rules'
        if ($Target -contains 'UserDefault') {
            Write-Verbose 'Load UserDefault Hive'
            REG LOAD HKLM\TempDefaultUser $Env:SystemDrive\Users\Default\NTUSER.DAT > $null
        }
    }
    Process {
        Switch ($Value)
        {
            'Automatically' {
                $pins = 99999; $nsip = 99999
            }
            'Always' {
                $pins = 100000000; $nsip = 99999
            }
            'Daily' {
                $pins = 864000000000; $nsip = 1
            }
            'Weekly' {
                $pins = 6048000000000; $nsip = 1
            }
            'Never' {
                $pins = 99999; $nsip = 0
            }
        }
        $Target | ForEach-Object {
            if ($_ -eq 'UserDefault') {
                $keyPath = Join-Path 'HKLM:\TempDefaultUser' $keyPath
            }
            elseif ($_ -eq 'CurrentUser') {
                $keyPath = Join-Path 'HKCU:' $keyPath
            }
            New-Item -ErrorAction SilentlyContinue -Path $keyPath -Force > $null
            Switch ($pins)
            {
                99999 {
                    if ($null -ne (Get-ItemProperty -Path $keyPath -Name PeriodInNanoSeconds -ErrorAction SilentlyContinue)) {
                        Remove-ItemProperty -Path $keyPath -Name PeriodInNanoSeconds
                    }
                }
                default {
                    Set-ItemProperty -ErrorAction SilentlyContinue -Path $keyPath -Name PeriodInNanoSeconds -Type 'Qword' -Value $pins -Force | Out-Null
                }
            }
            Switch ($nsip)
            {
                99999 {
                    if ($null -ne (Get-ItemProperty -Path $keyPath -Name NumberOfSIUFInPeriod -ErrorAction SilentlyContinue)) {
                        Remove-ItemProperty -Path $keyPath -Name NumberOfSIUFInPeriod
                    }
                }
                default {
                    Set-ItemProperty -ErrorAction SilentlyContinue -Path $keyPath -Name NumberOfSIUFInPeriod -Type 'Dword' -Value $nsip -Force | Out-Null
                }
            }
        }
    }
    End {
        if ($Target -contains 'UserDefault') {
            Write-Verbose 'Unload UserDefault Hive'
            REG UNLOAD HKLM\TempDefaultUser > $null
        }
    }
}