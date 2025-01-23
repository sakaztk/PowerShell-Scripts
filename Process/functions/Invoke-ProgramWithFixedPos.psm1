Function Invoke-ProgramWithFixedPos
{
    Param(
        [String]$Program,
        [Int]$X,
        [Int]$Y
    )
    Begin{
    Add-Type -Namespace Imports -Name User32 @'
[DllImport("user32.dll")]public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);
'@
    }
    Process
    {
        $process = [System.Diagnostics.Process]::Start($Program)
        $process.WaitForInputIdle() | Out-Null
        [Imports.User32]::SetWindowPos($process.MainWindowHandle, 0, $X, $Y, 0, 0, 1) | Out-Null
    }
}