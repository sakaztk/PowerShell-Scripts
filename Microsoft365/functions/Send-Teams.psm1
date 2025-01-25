function Send-Teams {
    param (
        [Parameter(mandatory=$true)]
        [String]$Message,
        [String]$Title = '',
        [ValidateSet('default','emphasis','good','attention','accent')]
        [String]$Style = "default",
        [String]$WebhookUrl = ''
    )
    $formattedOutput=''
    ($Message -split "\r?\n|\r") | ForEach-Object {
        #$line = [regex]::Escape("$_")
        $line = $_ -replace '\\', '\\' -replace '"', '`"'
        $formattedOutput += "
        {
            `"type`": `"TextBlock`",
            `"style`": `"blockquote`",
            `"size`": `"small`",
            `"spacing`": `"none`",
            `"wrap`": true,
            `"text`": `"$($line -replace '"', '`"')`"
        },"
    }
    $formattedOutput = $formattedOutput.TrimEnd(',')
    $adaptiveCardJson = @"
{
    "type": "message",
    "attachments": [
        {
            "contentType": "application/vnd.microsoft.card.adaptive",
            "content": {
                "`$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
                "type": "AdaptiveCard",
                "version": "1.5",
                "msteams": {
                    "width": "Full"
                },
                "body": [
                    {
                        "type": "Container",
                        "style": "$Style",
                        "bleed": true,
                        "spacing": "None",
                        "items": [
                            {
                                "type": "TextBlock",
                                "text": "[$([Environment]::UserName)@$env:COMPUTERNAME] $Title"
                            }
                        ]
                    },
                    $formattedOutput
                ]
            }
        }
    ]
}
"@

    $jsonBody = [System.Text.Encoding]::UTF8.GetBytes($adaptiveCardJson)
    Invoke-RestMethod -Uri $WebhookUrl -Method Post -ContentType 'application/json' -Body $jsonBody
}