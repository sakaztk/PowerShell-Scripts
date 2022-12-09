function Invoke-MessageBeep
{
    param (
        [BeepType]$BeepType = [beepType]::SimpleBeep
    )
    [User32]::MessageBeep($BeepType) >$null
}