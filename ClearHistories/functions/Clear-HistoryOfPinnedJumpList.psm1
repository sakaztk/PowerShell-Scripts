function Clear-HistoryOfPinnedJumpList
{
    Get-ChildItem "$env:APPDATA\Microsoft\Windows\Recent\CustomDestinations" -File | Foreach-Object {Remove-Item $_.FullName}
}
