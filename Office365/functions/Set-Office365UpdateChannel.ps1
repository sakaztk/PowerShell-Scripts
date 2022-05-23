Function Set-Office365UpdateChannel {
    Param (
        [Parameter (
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateSet('Monthly','Deferred')]
        [String]$Channel 
    )
    Begin {
        $regpathO365C2R = 'HKLM:\SOFTWARE\Microsoft\Office\ClickToRun'
        $regpathO365Config = 'HKLM:\SOFTWARE\Microsoft\Office\ClickToRun\Configuration'
        $regpathOfficeUpdate = 'HKLM:\SOFTWARE\Policies\Microsoft\Office\16.0\Common\OfficeUpdate'
        $deferredChannelURL = 'http://officecdn.microsoft.com/pr/7ffbc6bf-bc32-4f92-8982-f9dd17fd3114'
        $monthlyChannelURL  = 'http://officecdn.microsoft.com/pr/492350f6-3a01-4f97-b9c0-c7c6ddf67d60'
        $officeC2RPAth = "$env:CommonProgramFiles\microsoft shared\ClickToRun\OfficeC2RClient.exe"
    }
    Process {
        if (Get-ItemProperty $regpathO365Config CDNBaseUrl) {
            switch ($Channel) {
                'Monthly'{$channelURL = $monthlyChannelURL}
                'Deferred'{$channelURL = $deferredChannelURL}
            }
            Try {
                Set-ItemProperty -Path $regpathO365Config -Name CDNBaseUrl -Value $channelURL
            }
            Catch {
                Write-Error 'Failed to change update Channel.'
            }
            Remove-ItemProperty -Path $regpathO365Config -Name UpdateUrl -Force 2>$null
            Remove-ItemProperty -Path $regpathO365Config -Name UpdateToVersion -Force 2>$null
            Remove-ItemProperty -Path $regpathO365C2R -Name UpdateToVersion -Force 2>$null
            Remove-Item -Path $regpathOfficeUpdate -Recurse -Force 2>$null
            Start-Process -FilePath $officeC2RPAth -ArgumentList "/update", "user"
        }
        else {
            $false
        }
    }
}