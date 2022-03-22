function Get-WindowsLibrary {
    [CmdletBinding()]
    Param(
        [ValidateScript({Test-Path $_ -PathType Container})]
        [String]$Path = (Join-Path $env:APPDATA '\Microsoft\Windows\Libraries')
    )
    New-Object -TypeName PSObject -Property @{
        State = Get-WindowsLibraryState
        DefaultPath = $Path
    }
}