function Remove-Library {
    param (
        [Parameter(
            Position = 1,
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [String]$LibraryName
        ,
        [ValidateScript({Test-Path $_ -PathType Container})]
        [String]$LibraryPath = $(Join-Path $env:APPDATA '\Microsoft\Windows\Libraries')
    )
    process {
        $fileName = $LibraryName + '.library-ms'
        $itemPath = Join-Path $LibraryPath $fileName
        Remove-Item -Path $itemPath -Force
    }
}