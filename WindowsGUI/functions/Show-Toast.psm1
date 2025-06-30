Function Show-Toast {
    [CmdletBinding()]
    Param (
        [String]$Title,
        [String]$Message,
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
            'ms-winsoundevent:Notification.Looping.Call',
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
        [Switch]$AudioLoop
    )
    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    [Windows.UI.Notifications.ToastNotification, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

    $appId = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'
    if ($Audio -eq 'silent') {
        $XmlAudio = "<audio silent=`"true`"/>"
    }
    elseif ($AudioLoop) {
        $XmlAudio = "<audio src=`"$Audio`" loop=`"true`"/>"
    }
    else {
        $XmlAudio = "<audio src=`"$Audio`" loop=`"false`"/>"
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
            <text>$($title)</text>
            <text>$($message)</text>
        </binding>
    </visual>
</toast>
"@
    $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
    $xml.LoadXml($content)
    $toast = New-Object Windows.UI.Notifications.ToastNotification $xml
    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($appId).Show($toast)
}