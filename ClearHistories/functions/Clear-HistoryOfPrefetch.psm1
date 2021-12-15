function Clear-HistoryOfPrefetch
{
    Remove-Item $env:windir\Prefetch\*
}
