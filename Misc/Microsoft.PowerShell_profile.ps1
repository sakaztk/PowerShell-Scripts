# https://docs.microsoft.com/powershell/module/microsoft.powershell.core/about/about_profiles
$OutputEncoding = [System.Console]::OutputEncoding = [System.Console]::InputEncoding = [System.Text.Encoding]::GetEncoding('utf-8')

function prompt {
    $isAdmin = (([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
    if ($isAdmin) {
        $color = 'Magenta'; $marker = '#'
    }
    else {
        $color = 'Green'; $marker = '$'
    }
    Write-Host "$env:UserName $pwd $marker" -ForegroundColor $color -NoNewline
    return " "
}

Write-Host -ForegroundColor Cyan -Object ( `
        "$(Get-Date) ($((Get-TimeZone).Id))`r`n" + `
        "Hello $env:UserName. This is PowerShell $($PSVersionTable.PSVersion.ToString()).`r`n"
)