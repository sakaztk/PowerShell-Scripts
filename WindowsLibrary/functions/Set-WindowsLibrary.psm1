function Set-WindowsLibrary {
    [CmdletBinding()]
    Param (
        [Parameter(
            Position = 1,
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateSet('Enable', 'Disable')]
        [String]$State
        ,
        [Parameter(
            Position = 2,
            ValueFromPipelineByPropertyName = $true
        )]
        [Switch]$Passthru
    )
    try
    {
        Invoke-Expression ($State + '-WindowsLibrary')
    }
    catch
    {
        throw
    }
    if ( $Passthru ) {
        Get-WindowsLibrary
    }
}