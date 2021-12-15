function Clear-HistoryOfUserTemp
{
    Remove-Item $env:LOCALAPPDATA\temp\* -Recurse -ErrorAction SilentlyContinue
}