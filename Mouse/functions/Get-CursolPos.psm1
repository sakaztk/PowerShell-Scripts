function Get-CursolPos {
    $pt = New-Object -TypeName Mouse.Point
    [void][Mouse.Methods]::GetCursorPos([ref]$pt)
    $pt
}

<#
function Get-CursolPos {
    [void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [System.Windows.Forms.Cursor]::Position
}
#>