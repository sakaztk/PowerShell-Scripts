<#
.EXAMPLE
$ips = foreach ($oct1 in 192) {
    foreach ($oct2 in 168) {
        foreach ($oct3 in 0..1) {
            foreach ($oct4 in 1..254) {
                "$oct1.$oct2.$oct3.$oct4"
            }
        }
    }
}
Invoke-ParallelPing $ips | Where-Object {$_.Status -eq 'Success'}
.LINK
https://github.com/sakaztk/PowerShell-Scripts
#>
function Invoke-ParallelPing {
    [CmdletBinding()]
    param(
        [string[]]$ips
    )

    $tasks = $ips | ForEach-Object {
        Write-Verbose "Pinging: $_"
        [System.Net.NetworkInformation.Ping]::New().SendPingAsync($_)
    }
    [System.Threading.Tasks.Task]::WaitAll($tasks)
    $tasks.Result
}


<# osoiyo!
Workflow Invoke-ParallelPing {
    [CmdletBinding()]
    param([string[]]$ips)

    foreach -parallel($ip in $ips)
    {
        Write-Verbose "Pinging: $ip"
        Test-Connection -ipaddres $ip -Count 1 -ErrorAction SilentlyContinue
    }
}
#>

<# koremo osoine...
function Invoke-ParallelPing {
    [CmdletBinding()]
    param([string[]]$ips)

    $ips | ForEach-Object {
        Write-Verbose "Pinging: $_"
        Start-Job {Test-Connection -ipaddres $_ -Count 2 -ErrorAction SilentlyContinue} | Out-Null
    }
    get-job | Wait-Job -Any | Out-Null
}
#>