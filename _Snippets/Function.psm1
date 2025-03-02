# https://learn.microsoft.com/powershell/module/microsoft.powershell.core/about/about_functions
function CmdletBinding {
    [CmdletBinding(
        ConfirmImpact = 'Medium', # High / Medium / Low / None
        DefaultParameterSetName = '',
        HelpURI = '',
        SupportsPaging = $false,
        SupportsShouldProcess = $false,
        PositionalBinding = $true
    )]
    Param ()
    begin{}
    process{}
    end{}
}

function Argument {
    [CmdletBinding()]
    Param (
        [Parameter (
            Mandatory = $false,
            Position = 0,
            ParameterSetName = '',
            ValueFromPipeline = $false,
            ValueFromPipelineByPropertyName = $false,
            ValueFromRemainingArguments = $false,
            HelpMessage = ''
        )]
        [string]$ComputerName
    )
    begin{}
    process{}
    end{}
}

function Attribute {
    [CmdletBinding()]
    Param (
        [Alias('HostName','MachineName')]
        [PSDefaultValue(Help='Name of this Computer')]
        [string]$ComputerName = $env:COMPUTERNAME
        ,
        [System.Management.Automation.Credential()]
        [PSCredential]$Credential
        ,
        [PSTypeName('Microsoft.PowerShell.Commands.TestConnectionCommand+PingMtuStatus')]
        [psobject]$MtuStatus
        ,
        [System.Obsolete("The NoTypeInformation parameter is obsolete.")]
        [SwitchParameter]$NoTypeInformation
        ,
        [SupportsWildcards()]
        [string[]]$Path
    )
    begin{}
    process{}
    end{}
}

function Validation {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [AllowNull()]
        [hashtable]$ComputerInfo
        ,
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]]$Computer
        ,
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string]$ComputerName
        ,
        [ValidateCount(1,5)]
        [string[]]$Name
        ,
        [ValidateLength(1,5)]
        [string]$Text
        ,
        [ValidatePattern("[0-9]{4}")]
        [string]$id
        ,
        [ValidateRange(0,10)]
        [Int]$Attempts
        ,
        [ValidateRange("Positive")]
        [int]$number = 1
        ,
        [ValidateScript(
            {$_ -ge (Get-Date)},
            ErrorMessage = "{0} isn't a future date. Specify a later date."
        )]
        [DateTime]$EventDate
        ,
        [ValidateSet("Low", "Average", "High")]
        [string[]]$Detail
        ,
        [ValidateNotNull()]
        $notnull
        ,
        [ValidateNotNullOrEmpty()]
        [string[]]$notnullempty
        ,
        [ValidateNotNullOrWhiteSpace()]
        [string[]]$notnullspace
        ,
        [ValidateDrive("C", "D", "Variable", "Function")]
        [string]$Path
    )
    begin{}
    process{}
    end{}
}
