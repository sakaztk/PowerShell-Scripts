Function Get-AuthentiCodeStates{
    [CmdletBinding()]
    Param(
        [ValidateScript({Test-Path $_ -PathType 'Container'})]
        [String]$Path = $(Get-Location).Path,
        [Int]$Depth=1,
        [String[]]$Ext,
        [Switch]$Recurse
    )
    Process{
        if ($Recurse) {
            if ($Ext -isnot [array] -and $null -eq $Ext) {
                $items = Get-ChildItem -Path $Path -Force -Recurse | Where-Object {
                    ($_.Attributes -notmatch "System") `
                    -and ($_.Attributes -notmatch "ReparsePoint") `
                    -and ($_.Attributes -notmatch "Directory")
                }
            }
            else {
                $itemsStr = "Get-ChildItem -Path `$Path -Force -Recurse | Where-Object {(`$_.Attributes -notmatch `"ReparsePoint`") -and (`$_.Attributes -notmatch `"Directory`") -and"
                foreach ($extStr in $Ext) {
                    $itemsStr = $itemsStr + " `$_.extension -eq '" + $extStr + "' -or"
                }
                $itemsStr = $itemsStr.Remove($itemsStr.Length - 4, 4) + "}"
                $items = Invoke-Expression $itemsStr
            }
        }
        else {
            for ($i=1; $i -le $Depth; $i++) {
                if ($Ext -isnot [array] -and $null -eq $Ext) {
                    $items = Get-ChildItem -Path ($Path + "\*" * $i).Replace("\\*","\*") -Force | Where-Object {
                        ($_.Attributes -notmatch "System") `
                        -and ($_.Attributes -notmatch "ReparsePoint") `
                        -and ($_.Attributes -notmatch "Directory")
                    }
                }
                else {
                    $itemsStr = "Get-ChildItem -Path (`$Path + `"\*`" * `$i).Replace(`"\\*`",`"\*`") | Where {(`$_.Attributes -notmatch `"ReparsePoint`") -and (`$_.Attributes -notmatch `"Directory`") -and"
                    foreach ($extStr in $Ext) {
                        $itemsStr = $itemsStr + " `$_.extension -eq '" + $extStr + "' -or"
                    }
                    $itemsStr = $itemsStr.Remove($itemsStr.Length - 4, 4) + "}"
                    $items = Invoke-Expression $itemsStr
                }
            }
        }
        foreach ($item in $items){
            New-Object -TypeName PSObject -Property @{
            Path = $item.FullName
            Status = (Get-AuthenticodeSignature $item.FullName).Status
            }
        }
    }
}
