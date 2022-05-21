function Invoke-Click {
    #$MOUSEEVENTF_LEFTDOWN = 0x0002
    #$MOUSEEVENTF_LEFTUP = 0x0004
    [Mouse.Methods]::mouse_event($MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0)
    [Mouse.Methods]::mouse_event($MOUSEEVENTF_LEFTUP, 0, 0, 0, 0)
}