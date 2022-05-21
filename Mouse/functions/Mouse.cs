using System.Runtime.InteropServices;

namespace Mouse
{
    public struct POINT
    {
        public int X;
        public int Y;
    }
    public class Methods
    {
        [DllImport("user32.dll")]public static extern void mouse_event(uint dwFlags, uint dx, uint dy, uint dwData, int dwExtraInfo);
        [DllImport("user32.dll")]public static extern bool SetCursorPos(int X, int Y);
        [DllImport("user32.dll")]public static extern bool GetCursorPos(out POINT lpPoint);
    }
}