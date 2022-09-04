#https://docs.microsoft.com/dotnet/framework/migration-guide/how-to-determine-which-versions-are-installed?redirectedfrom=MSDN
function Get-DotNetVersion
{
    Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -recurse |
    Get-ItemProperty -name Version,Release -ErrorAction SilentlyContinue |
    Where-Object { $_.PSChildName -match '^(?!S)\p{L}'} |
    Select-Object PSChildName, Version, Release, @{
        name='Product'
        expression= {
            switch($_.Release) {
                378389 { '4.5' }
                378675 { '4.5.1' }
                378758 { '4.5.1' }
                379893 { '4.5.2' }
                393295 { '4.6' }
                393297 { '4.6' }
                394254 { '4.6.1' }
                394271 { '4.6.1' }
                394802 { '4.6.2' }
                394806 { '4.6.2' }
                460798 { '4.7' }
                460805 { '4.7' }
                461308 { '4.7.1' }
                461310 { '4.7.1' }
                461808 { '4.7.2' }
                461814 { '4.7.2' }
                528040 { '4.8' }
                528049 { '4.8' }
                528372 { '4.8' }
                528449 { '4.8' }
                533325 { '4.8.1' }
            }
        }
    }
}