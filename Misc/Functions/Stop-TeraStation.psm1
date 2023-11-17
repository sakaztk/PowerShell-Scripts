# https://github.com/placebovitamin/Buffalo_NAS_shutdown/blob/main/shutdown.py

function Stop-TeraStation {
    [CmdletBinding()]
    Param(
        [IPAddress]$IPAddress,
        [String]$User = 'admin',
        [String]$Passwd = 'password'
    )    
    $nasApi = "http://$($IPAddress.IPAddressToString)/nasapi"
    #Login
    $json = @{jsonrpc='2.0';method='Auth.login';params=@{username=$user;password=$passwd;};id='9999'} | ConvertTo-Json -Compress
    $body = [Text.Encoding]::UTF8.GetBytes($json)
    $response = Invoke-RestMethod -Method POST -Uri $nasapi -Body $body -ContentType application/json
    #Shutdown
    $sid = $response.result.sid
    $json =  @{jsonrpc='2.0';method='System.shutdown';params=@{sid=$sid};id='9999'} | ConvertTo-Json -Compress
    $body = [Text.Encoding]::UTF8.GetBytes($json)
    $response = Invoke-RestMethod -Method POST -Uri $nasapi -Body $body -ContentType application/json
}