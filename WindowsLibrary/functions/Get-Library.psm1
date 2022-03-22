function Get-Library {
    [CmdletBinding()]
    param (
        [Parameter(
            Position = 1,
            ValueFromPipeline = $true
        )]
        [String[]]$LibraryName = '*'
        ,
        [Parameter(
            Position = 2,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateScript({Test-Path $_ -PathType Container})]
        [String]$LibraryPath = (Join-Path $env:APPDATA '\Microsoft\Windows\Libraries')
    )
    process {
        if ( $LibraryName -eq '*' ) {
            $items = Get-ChildItem "$LibraryPath\*library-ms"
            $items | ForEach-Object {
                $xml = [Xml](Get-Content $_.FullName -Encoding UTF8)
                $path = $xml.CreateNode('element', 'Path', '')
                $urlText = $xml.CreateTextNode($_.FullName)
                $path.AppendChild($urlText) | Out-Null
                $xml.libraryDescription.AppendChild($path) | Out-Null
                $xml.libraryDescription
            }    
        }
        else {
            $LibraryName | ForEach-Object {
                $xml = [Xml](Get-Content "$LibraryPath\$_.library-ms" -Encoding UTF8)
                $path = $xml.CreateNode('element', 'Path', '')
                $urlText = $xml.CreateTextNode("$LibraryPath\$_.library-ms")
                $path.AppendChild($urlText) | Out-Null
                $xml.libraryDescription.AppendChild($path) | Out-Null
                $xml.libraryDescription
            }
        }
    }
}