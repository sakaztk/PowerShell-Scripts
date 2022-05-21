function Invoke-MiddleClick {
    #$MOUSEEVENTF_MIDDLEDOWN = 0x0020
    #$MOUSEEVENTF_MIDDLEUP = 0x0040
    [Mouse.Methods]::mouse_event($MOUSEEVENTF_MIDDLEDOWN, 0, 0, 0, 0)
    [Mouse.Methods]::mouse_event($MOUSEEVENTF_MIDDLEUP, 0, 0, 0, 0)
}