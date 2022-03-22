function Enable-LibraryPinned {
    param (
        [Parameter(
            Position = 1,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String[]]$LibraryName
        ,
        [Parameter(
            Position = 2,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateScript({Test-Path $_ -PathType Container})]
        [String]$LibraryPath = (Join-Path $env:APPDATA '\Microsoft\Windows\Libraries')
        ,
        [Parameter(
            Position = 3,
            ValueFromPipelineByPropertyName = $true
        )]
        [Switch]$Passthru
    )
    process {
        $LibraryName | ForEach-Object {
            $fileName = $_ + '.library-ms'
            $filePath = Join-Path $LibraryPath $fileName
            if ( Test-Path $filePath ) {
                $xml = [Xml](Get-Content $filePath -Encoding UTF8)
                $xml.libraryDescription.isLibraryPinned = 'True'
                $xml.Save($filePath)
                if ( $Passthru ) {
                    Get-LibraryPinned -LibraryName $_ -LibraryPath $LibraryPath
                }    
            }
            else {
                throw 'Library file does not exist.'
            }
        }
    }
}