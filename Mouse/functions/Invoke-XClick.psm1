function Invoke-XClick {
    #$MOUSEEVENTF_XDOWN = 0x0080
    #$MOUSEEVENTF_XUP = 0x0100
    [Mouse.Methods]::mouse_event($MOUSEEVENTF_XDOWN, 0, 0, 0, 0)
    [Mouse.Methods]::mouse_event($MOUSEEVENTF_XUP, 0, 0, 0, 0)
}