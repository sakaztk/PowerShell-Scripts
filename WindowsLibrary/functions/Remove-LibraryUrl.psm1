function Remove-LibraryUrl {
    param (
        [Parameter(
            Position = 1,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [String[]]$LibraryName
        ,
        [Parameter(
            Position = 2,
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateScript({Test-Path $_})]
        [String[]]$URLPath
        ,
        [Parameter(
            Position = 3,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateScript({Test-Path $_ -PathType Container})]
        [String[]]$LibraryPath = (Join-Path $env:APPDATA '\Microsoft\Windows\Libraries')
        ,
        [Parameter(
            Position = 4,
            ValueFromPipelineByPropertyName = $true
        )]
        [Switch]$Passthru
    )
    process {
        $LibraryPath | ForEach-Object {
            $targetLibraryPath = $_
            $LibraryName | ForEach-Object {
                $targetLibraryName = $_
                $fileName = $targetLibraryName + '.library-ms'
                $itemPath = Join-Path $LibraryPath $fileName
                if ( Test-Path $itemPath ) {
                    try {
                        $xml = [Xml](Get-Content $itemPath -Encoding UTF8)
                        $URLPath | ForEach-Object {
                            if ( $xml.libraryDescription.searchConnectorDescriptionList.searchConnectorDescription.simpleLocation.url -contains $_ ) {
                                $searchPath = $_
                                $xml.libraryDescription.searchConnectorDescriptionList | ForEach-Object {
                                    if ( $_.searchConnectorDescription.simpleLocation.url -eq $searchPath ) {
                                        $_.ParentNode.RemoveChild($_) | Out-Null
                                    }
                                }
                                $xml.Save($itemPath)
                            }
                            else {
                                Write-Host "Does not exists $_."
                            }
                        }
                        if ( $Passthru ) {
                            Get-LibraryUrl -LibraryPath $targetLibraryPath -LibraryName $targetLibraryName
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