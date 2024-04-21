function Get-ADSchemaVersion {
    [PSCustomObject][Ordered]@{
        'Windows Server 2000' = 13
        'Windows Server 2003' = 30
        'Windows Server 2003 R2' = 31
        'Windows Server 2008' = 44
        'Windows Server 2008 R2' = 47
        'Windows Server 2012' = 56
        'Windows Server 2012 R2' = 69
        'Windows Server 2016' = 87
        'Windows Server 2019' = 88
        'Windows Server 2022' = 98
        'Current' = (Get-ADObject (Get-ADRootDSE).SchemaNamingContext -Property ObjectVersion).ObjectVersion
    }
}
