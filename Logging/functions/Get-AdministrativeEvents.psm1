function Get-AdministrativeEvents {
    [CmdletBinding(DefaultParameterSetName = 'object')]
    param (
        [Parameter(ParameterSetName='object')]
        [Parameter(ParameterSetName='evtx')]
        [Int]$Seconds = 0,
        [Parameter(ParameterSetName='evtx')]
        [Switch]$evtx,
        [Parameter(ParameterSetName='evtx', Mandatory=$true)]
        [System.IO.FileInfo]$To,
        [Parameter(ParameterSetName='evtx')]
        [Switch]$Overwrite
    )
    $filterXML = "$($env:TEMP)\AdministrativeEvents.xml"
    $loglist = @()
    Get-WinEvent -Force -ListLog * -ErrorAction SilentlyContinue | ForEach-Object {
        if ($_.LogType -eq "Administrative") {
            $logList += $_.logName
        }
    }
    Set-Content $filterXML "<QueryList>`r`n  <Query Id=`"0`" Path=`"Application`">"
    $logList | ForEach-Object {
        if (0 -eq $Seconds) {
            Add-Content $filterXML "    <Select Path=`"$($_)`">*[System[(Level=1 or Level=2 or Level=3)]]</Select>"
        }
        else {
            Add-Content $filterXML "    <Select Path=`"$($_)`">*[System[(Level=1 or Level=2 or Level=3) and TimeCreated[timediff(@SystemTime) &lt;= $($Seconds*1000)]]]</Select>"
        }
    }
    Add-Content $filterXML "  </Query>`r`n</QueryList>"
    if ($evtx) {
        wevtutil export-log $filterXML $to /structuredquery:true /overwrite:$Overwrite
    }
    else {
        Get-WinEvent -FilterXml ([xml](Get-Content $filterXML)) -ErrorAction SilentlyContinue
    }
    Remove-Item -Path $filterXML -Force
}