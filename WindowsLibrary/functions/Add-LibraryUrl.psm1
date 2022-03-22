function Add-LibraryUrl {
    param (
        [Parameter(
            Position = 1,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String]$LibraryName
        ,
        [Parameter(
            Position = 2,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateScript({Test-Path $_})]
        [String]$URLPath
        ,
        [Parameter(
            Position = 3,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateScript({Test-Path $_ -PathType Container})]
        [String]$LibraryPath = (Join-Path $env:APPDATA '\Microsoft\Windows\Libraries')
        ,
        [Parameter(
            Position = 4,
            ValueFromPipelineByPropertyName = $true
        )]
        [Switch]$Passthru
    )
    process {
        $fileName = $LibraryName + '.library-ms'
        $itemPath = Join-Path $LibraryPath $fileName
        if ( Test-Path $itemPath ) {
            try {
                $xml = [Xml](Get-Content $itemPath -Encoding UTF8)
                if ( $xml.libraryDescription.searchConnectorDescriptionList.searchConnectorDescription.simpleLocation.url -notcontains $URLPath ) {
                    $url = $xml.CreateNode('element', 'url', '')
                    $urlText = $xml.CreateTextNode($UrlPath)
                    $url.AppendChild($urlText) | Out-Null
                    $simpleLocation = $xml.CreateNode('element', 'simpleLocation', '')
                    $simpleLocation.AppendChild($url) | Out-Null
                    $searchConnectorDescription = $xml.CreateNode('element', 'searchConnectorDescription', '')
                    $searchConnectorDescription.AppendChild($simpleLocation) | Out-Null
                    $searchConnectorDescriptionList = $xml.CreateNode('element', 'searchConnectorDescriptionList', '')
                    $searchConnectorDescriptionList.AppendChild($searchConnectorDescription) | Out-Null
                    $xml.libraryDescription.AppendChild($searchConnectorDescriptionList) | Out-Null
                    $xml.Save($itemPath)
                }
                else {
                    Write-Host "Already exists $URLPath."
                }
                if ( $Passthru ) {
                    Get-LibraryUrl -LibraryPath $LibraryPath -LibraryName $LibraryName
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