function Set-SoundVolume
{
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange(0,100)]
        [int]$Volume
    )
    [Audio.Sound]::Volume = $Volume / 100
}
