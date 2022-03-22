function Get-WindowsLibraryState {
    $regValue = (Get-ItemProperty 'HKCU:\Software\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}').'System.IsPinnedToNameSpaceTree'
    switch ($regValue) {
        0 {
            return 'Disabled'
        }
        1 {
            return 'Enabled'
        }
        default {
            return 'Unknown'
        }
    }
}