function Invoke-SoundUnmute
{
    [Audio.Sound]::Mute = $false
}
