function Get-SpecialFolders {
    $folders = [enum]::GetNames([System.Environment+SpecialFolder])
    $folders | ForEach-Object {
        New-Object -TypeName PSObject -Property @{
            Name = $_
            Path = [Environment]::GetFolderPath($_)
        } | Select-Object Name, Path
    }
}