function Clear-HistoryOfRecent
{
    Get-ChildItem "$env:APPDATA\Microsoft\Windows\Recent" -File | Foreach-Object {Remove-Item $_.FullName}
}
