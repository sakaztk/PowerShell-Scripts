function Clear-HistoryOfJumpList
{
    Get-ChildItem "$env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations" -File | Foreach-Object {Remove-Item $_.FullName}
}
