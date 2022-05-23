function ConvertTo-UnsecureString {
    Param (
        [System.Security.SecureString]$SecurePassword
    )
    Process {
        $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)
        return [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
    }
}