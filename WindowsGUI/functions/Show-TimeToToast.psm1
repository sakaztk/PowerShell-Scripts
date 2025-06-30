Function Show-TimeToToast {
    [CmdletBinding()]
    Param (
        [ValidateSet('short', 'long')]
        [String]$Duration = 'short',
        [ValidateSet('reminder', 'alarm', 'incomingCall', 'urgent')]
        [String]$Scenario = 'reminder',
        [ValidateSet('false', 'true')]
        [String]$UseButtonStyle = 'false',
        [ValidateSet(
            'ms-winsoundevent:Notification.Default',
            'ms-winsoundevent:Notification.IM',
            'ms-winsoundevent:Notification.Mail',
            'ms-winsoundevent:Notification.Reminder',
            'ms-winsoundevent:Notification.SMS',
            'ms-winsoundevent:Notification.Looping.Alarm',
            'ms-winsoundevent:Notification.Looping.Alarm2',
            'ms-winsoundevent:Notification.Looping.Alarm3',
            'ms-winsoundevent:Notification.Looping.Alarm4',
            'ms-winsoundevent:Notification.Looping.Alarm5',
            'ms-winsoundevent:Notification.Looping.Alarm6',
            'ms-winsoundevent:Notification.Looping.Alarm7',
            'ms-winsoundevent:Notification.Looping.Alarm8',
            'ms-winsoundevent:Notification.Looping.Alarm9',
            'ms-winsoundevent:Notification.Looping.Alarm10',
            'ms-winsoundevent:Notification.Looping.Call2',
            'ms-winsoundevent:Notification.Looping.Call3',
            'ms-winsoundevent:Notification.Looping.Call4',
            'ms-winsoundevent:Notification.Looping.Call5',
            'ms-winsoundevent:Notification.Looping.Call6',
            'ms-winsoundevent:Notification.Looping.Call7',
            'ms-winsoundevent:Notification.Looping.Call8',
            'ms-winsoundevent:Notification.Looping.Call9',
            'ms-winsoundevent:Notification.Looping.Call10',
            'silent'
        )]
        [String]$Audio = 'ms-winsoundevent:Notification.Default',
        [ValidateSet('false', 'true')]
        [String]$AudioLoop = 'false',
        [Int]$ForSeconds = 10
    )

    if ($Audio -eq 'silent') {
        $XmlAudio = "<audio silent=`"true`"/>"
    }
    else {
        $XmlAudio = "<audio src=`"$Audio`" loop=`"$AudioLoop`"/>"
    }
    $content = @"
<?xml version="1.0" encoding="utf-8"?>
<toast
    duration = "$Duration"
    scenario = "$Scenario"
    useButtonStyle = "$UseButtonStyle">
    $XmlAudio
    <visual>
        <binding template="ToastGeneric">
            <text>{timeNow}</text>
        </binding>
    </visual>
</toast>
"@
    $xmlDocument = [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]::New()
    $xmlDocument.loadXml($content)
    $toastNotification = [Windows.UI.Notifications.ToastNotification, Windows.UI.Notifications, ContentType = WindowsRuntime]::New($xmlDocument)
    $toastNotification.Tag = 'my_countdown'
    $Dictionary = [System.Collections.Generic.Dictionary[String, String]]::New()
    $Dictionary.Add('timeNow', [datetime]::Now.ToString("HH:mm:ss"))
    $toastNotification.Data = [Windows.UI.Notifications.NotificationData]::New($Dictionary)
    $toastNotification.Data.SequenceNumber = 1
    $appId = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'
    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($appId).Show($toastNotification)

    for ($index = 1; $index -le $ForSeconds; $index++) {
        Start-Sleep 1
        $Dictionary = [System.Collections.Generic.Dictionary[String, String]]::New()
        $Dictionary.Add('timeNow', [datetime]::Now.ToString("HH:mm:ss"))
        $NotificationData = [Windows.UI.Notifications.NotificationData]::New($Dictionary)
        $NotificationData.SequenceNumber = 2
        [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($appId).Update($NotificationData, 'my_countdown') | Out-Null
    }
    
}