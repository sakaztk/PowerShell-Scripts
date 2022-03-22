function Test-LibraryPinned {
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param (
        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true
        )]
        [String]$LibraryName
        ,
        [ValidateScript({Test-Path $_ -PathType Container})]
        [String]$LibraryPath = (Join-Path $env:APPDATA '\Microsoft\Windows\Libraries')
    )
    process {
        $fileName = $LibraryName + '.library-ms'
        $libraryPath = Join-Path $LibrarysFolder $fileName
        $xml = [Xml](Get-Content $libraryPath -Encoding UTF8)
        $xml.libraryDescription.isLibraryPinned -eq 'True'
    }
}