function New-Library {
    param (
        [Parameter(
            Position = 1,
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [String]$LibraryName
        ,
        [ValidateScript({Test-Path $_ -PathType Container})]
        [String]$LibraryPath = (Join-Path $env:APPDATA '\Microsoft\Windows\Libraries')
        ,
        [Switch]$Passthru
    )
    begin {
        $currentUserSid = ([System.Security.Principal.WindowsIdentity]::GetCurrent()).user.value
        $defaultXmlContent = @"
<?xml version="1.0" encoding="UTF-8"?>
<libraryDescription xmlns="http://schemas.microsoft.com/windows/2009/library">
  <ownerSID>$currentUserSid</ownerSID>
  <version>1</version>
  <isLibraryPinned>true</isLibraryPinned>
</libraryDescription>
"@
    }
    process {
        $fileName = $LibraryName + '.library-ms'
        $newLibraryPath = Join-Path $LibraryPath $fileName
        if ( Test-Path $newLibraryPath ) {
            throw 'Target library already exists.'
        }
        else {
            Out-File -FilePath $newLibraryPath -InputObject $defaultXmlContent -Encoding utf8
            if ( $Passthru ) {
                Get-Library -LibraryPath $LibraryPath -LibraryName $LibraryName
            }
        }
    }
}