#.ExternalHelp Show-AutoLogon.psm1-Help.xml
function Show-AutoLogon {
    [CmdletBinding()]
    param(
        [String]$UICulture = (Get-UICulture).Name
    )
    Begin {
        Push-Location $PSScriptRoot
        Import-LocalizedData LocalizedData -FileName Show-AutoLogon.Localize.psd1 -UICulture $UICulture
        Pop-Location
        Add-Type -AssemblyName PresentationFramework
        [xml]$xaml = @'
<Window
    xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="Auto Logon" Height="200" Width="230" ResizeMode="NoResize">
    <Grid>
        <CheckBox
            x:Name="chkEnableAL"
            Content="Enable Auto Logon"
            VerticalAlignment="Top"
            HorizontalAlignment="Left"
            Margin="10,10,0,0"
        />
        <Label
            x:Name="lblUserName"
            Content="User Name"
            VerticalAlignment="Top"
            HorizontalAlignment="Left"
            Margin="10,30,0,0"
        />
        <Label
            x:Name="lblPassword"
            Content="Password"
            VerticalAlignment="Top"
            HorizontalAlignment="Left"
            Margin="10,60,0,0"
        />
        <Label
            x:Name="lblLogonCount"
            Content="Auto Logon Count"
            VerticalAlignment="Top"
            HorizontalAlignment="Left"
            Margin="10,90,0,0"
        />
        <TextBox
            x:Name="txtUserName"
            VerticalAlignment="Top"
            HorizontalAlignment="Left"
            TextWrapping="Wrap"
            Text=""
            Margin="85,35,0,0"
            Height="20"
            Width="120"
        />
        <TextBox
            x:Name="txtPassword"
            VerticalAlignment="Top"
            HorizontalAlignment="Left"
            TextWrapping="Wrap"
            Text=""
            Margin="85,65,0,0"
            Height="20"
            Width="120"
        />
        <TextBox
            x:Name="txtLogonCount"
            VerticalAlignment="Top"
            HorizontalAlignment="Left"
            TextWrapping="Wrap"
            Text=""
            Margin="135,95,0,0"
            Height="20"
            Width="70"
        />
        <Button
            x:Name="btnOK"
            Content="OK"
            VerticalAlignment="Top"
            HorizontalAlignment="Left"
            Margin="60,130,0,0"
            Width="70"
        />
        <Button
            x:Name="btnCancel"
            Content="Cancel"
            VerticalAlignment="Top"
            HorizontalAlignment="Left"
            Margin="135,130,0,0"
            Width="70"
        />
    </Grid>
</Window>
'@
        $reader = (New-Object System.Xml.XmlNodeReader $xaml)
        $window = [Windows.Markup.XamlReader]::Load($reader)
        $chkEnabled = $window.FindName("chkEnableAL")
        $lblUserName = $window.FindName("lblUserName")
        $lblPassword = $window.FindName("lblPassword")
        $lblLogonCount = $window.FindName("lblLogonCount")
        $txtUserName = $window.FindName("txtUserName")
        $txtPassword = $window.FindName("txtPassword")
        $txtLogonCount = $window.FindName("txtLogonCount")
        $btnOK = $window.FindName("btnOK")
        $btnCancel = $window.FindName("btnCancel")
    }
    Process {
        $window.Title = $LocalizedData.WindowTitle
        $window.Height = $LocalizedData.WindowHeight
        $window.Width = $LocalizedData.WindowWidth
        $chkEnabled.Content = $LocalizedData.CheckBoxEnableContent
        $chkEnabled.Margin = $LocalizedData.CheckBoxEnableMargin
        $lblUserName.Content = $LocalizedData.LabelUsernameContent
        $lblUserName.Margin = $LocalizedData.LabelUsernameMargin
        $lblPassword.Content = $LocalizedData.LabelPasswordContent
        $lblPassword.Margin = $LocalizedData.LabelPasswordMargin
        $lblLogonCount.Content = $LocalizedData.LabelLogoncountContent
        $lblLogonCount.Margin = $LocalizedData.LabelLogoncountMargin
        $txtUserName.Margin = $LocalizedData.TextBoxUsernameMargin
        $txtUserName.Height = $LocalizedData.TextBoxUsernameHeight
        $txtUserName.Width = $LocalizedData.TextBoxUsernameWidth
        $txtPassword.Margin = $LocalizedData.TextBoxPasswordMargin
        $txtPassword.Height = $LocalizedData.TextBoxPasswordHeight
        $txtPassword.Width = $LocalizedData.TextBoxPasswordWidth
        $txtLogonCount.Margin = $LocalizedData.TextBoxLogoncountMargin
        $txtLogonCount.Height = $LocalizedData.TextBoxLogoncountHeight
        $txtLogonCount.Width = $LocalizedData.TextBoxLogoncountWidth
        $btnOK.Content = $LocalizedData.ButtonOKContent
        $btnOK.Margin = $LocalizedData.ButtonOKMargin
        $btnOK.Height = $LocalizedData.ButtonOKHeight
        $btnOK.Width = $LocalizedData.ButtonOKWidth
        $btnCancel.Content = $LocalizedData.ButtonCancelContent
        $btnCancel.Margin = $LocalizedData.ButtonCancelMargin
        $btnCancel.Height = $LocalizedData.ButtonCancelHeight
        $btnCancel.Width = $LocalizedData.ButtonCancelWidth

        $reg = Get-AutoLogon
        $txtUserName.Text = $reg.UserName
        $txtPassword.Text = $reg.Password
        $txtLogonCount.Text = $reg.AutoLogonCount
        if ($reg.Enabled -eq $true) {
            $chkEnabled.IsChecked = $true
        }
        else {
            $chkEnabled.IsChecked = $false
            $txtUserName.IsEnabled = $false
            $txtPassword.IsEnabled = $false
            $txtLogonCount.IsEnabled = $false
        }
        $chkEnabled.Add_Checked({
            $txtUserName.IsEnabled = $true
            $txtPassword.IsEnabled = $true
            $txtLogonCount.IsEnabled = $true
        })
        $chkEnabled.Add_UnChecked({
            $txtUserName.IsEnabled = $false
            $txtPassword.IsEnabled = $false
            $txtLogonCount.IsEnabled = $false
        })
        $btnOK.add_Click({
            if(
                ($reg.UserName -eq $txtUserName.Text) `
                -and ($reg.AutoLogon -eq $txtLogonCount.Text) `
                -and ($reg.Password -eq $txtPassword.Text) `
                -and ($reg.Enabled -eq $chkEnabled.IsChecked)
            ) {
                Write-Verbose 'No Changes'
            }
            else {
                if ($chkEnabled.IsChecked) {
                    try {
                        Set-AutoLogon `
                            -UserName $txtUserName.Text `
                            -Password (ConvertTo-SecureString $txtPassword.Text -AsPlainText -Force) `
                            -AutoLogonCount $txtLogonCount.Text
                        Write-Verbose ('Set Auto Logon. ' + $txtUserName.text + '/' + $txtPassword.text + '/' + $txtLogonCount.text)
                    }
                    catch {
                        Write-Verbose 'Failed to Set Auto Logon.'
                        $window.Close()
                        throw
                    }
                }
                else {
                    try {
                        Disable-AutoLogon
                        Write-Verbose 'Disabled Auto Logon'
                    }
                    catch {
                        Write-Verbose 'Failed to Disable Auto Logon'
                        $window.Close()
                        throw
                    }
                }
            }
            $window.Close()
        })
        $btnCancel.add_Click({ 
            $window.Close()
        })
        $window.ShowDialog() > $null
    }
}