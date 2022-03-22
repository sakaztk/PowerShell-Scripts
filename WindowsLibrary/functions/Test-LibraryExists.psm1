function Test-LibraryExists {
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
        Test-Path (Join-Path $LibraryPath $fileName)
    }
}