function Set-CursolPos {
    param (
        [Int]$X,
        [Int]$Y
    )
    [void][Mouse.Methods]::SetCursorPos($X, $Y)
}

<#
function Set-CursolPos {
    param (
        [Int]$X,
        [Int]$Y
    )
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    $pt = New-Object -TypeName System.Drawing.Point($X, $Y)
    [System.Windows.Forms.Cursor]::set_Position($pt)
}
#>