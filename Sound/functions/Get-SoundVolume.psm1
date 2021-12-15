function Get-SoundVolume
{
    [int]([Audio.Sound]::Volume * 100)
}
