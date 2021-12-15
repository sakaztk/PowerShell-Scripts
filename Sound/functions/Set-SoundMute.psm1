function Set-SoundMute
{
    param
    (
        [boolean]$Mute = $true
    )
    [Audio.Sound]::Mute = $Mute
}
