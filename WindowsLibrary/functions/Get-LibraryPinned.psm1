function Get-LibraryPinned {
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
    )
    process {
        $LibraryPath | ForEach-Object {
            $targetLibraryPath = $_
            $LibraryName | ForEach-Object {
                $fileName = $_ + '.library-ms'
                $filePath = Join-Path $targetLibraryPath $fileName
                if ( Test-Path $filePath ) {
                    $xml = [Xml](Get-Content $filePath -Encoding UTF8)
                    $path = $xml.CreateNode('element', 'LibraryPath', '')
                    $pathText = $xml.CreateTextNode($targetLibraryPath)
                    $path.AppendChild($pathText) | Out-Null
                    $name = $xml.CreateNode('element', 'LibraryName', '')
                    $nameText = $xml.CreateTextNode($_)
                    $name.AppendChild($nameText) | Out-Null
                    $xml.libraryDescription | ForEach-Object {
                        $_.AppendChild($path) | Out-Null
                        $_.AppendChild($name) | Out-Null
                        $_
                    }
                }
                else {
                    throw 'Library file does not exist.'
                }
            }
        }
    }
}