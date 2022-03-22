function Get-LibraryUrl {
    param (
        [Parameter(
            Position = 1,
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [String[]]$LibraryName
        ,
        [Parameter(
            Position = 2,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateScript({Test-Path $_ -PathType Container})]
        [String[]]$LibraryPath = (Join-Path $env:APPDATA '\Microsoft\Windows\Libraries')
    )
    process {
        $LibraryPath | ForEach-Object {
            $targetLibraryPath = $_
            $LibraryName | ForEach-Object {
                $fileName = $_ + '.library-ms'
                $itemPath = Join-Path $targetLibraryPath $fileName
                if ( Test-Path $itemPath ) {
                    try {
                        $xml = [Xml](Get-Content $itemPath -Encoding UTF8)
                        $path = $xml.CreateNode('element', 'LibraryPath', '')
                        $pathText = $xml.CreateTextNode($targetLibraryPath)
                        $path.AppendChild($pathText) | Out-Null
                        $name = $xml.CreateNode('element', 'LibraryName', '')
                        $nameText = $xml.CreateTextNode($_)
                        $name.AppendChild($nameText) | Out-Null
                        $xml.libraryDescription.searchConnectorDescriptionList.searchConnectorDescription.simpleLocation | ForEach-Object {
                            $_.AppendChild($path) | Out-Null
                            $_.AppendChild($name) | Out-Null
                            $_
                        }
                    }
                    catch {
                        throw
                    }
                }
                else {
                    throw 'Target library does not exists.'
                }
            }
        }
    }
}