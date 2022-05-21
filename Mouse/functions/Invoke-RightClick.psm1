function Invoke-RightClick {
    #$MOUSEEVENTF_RIGHTDOWN = 0x0008
    #$MOUSEEVENTF_RIGHTUP = 0x0010
    [Mouse.Methods]::mouse_event($MOUSEEVENTF_RIGHTDOWN, 0, 0, 0, 0)
    [Mouse.Methods]::mouse_event($MOUSEEVENTF_RIGHTUP, 0, 0, 0, 0)
}