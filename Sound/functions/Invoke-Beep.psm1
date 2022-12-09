function Invoke-Beep
{
    param (
        [ValidateRange(0x25, 0x7fff)]
        [Parameter(Mandatory)]
        [uint32]$Freq,
        [Parameter(Mandatory)]
        [uint32]$Milliseconds
    )
    [kernel32]::Beep($Freq, $Milliseconds) >$null
}
