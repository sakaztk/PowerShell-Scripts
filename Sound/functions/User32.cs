using System.Runtime.InteropServices;

public enum BeepType : uint
{
    SimpleBeep = 0xFFFFFFFF,
    OK = 0x00,
    Question = 0x20,
    Exclamation = 0x30,
    Asterisk = 0x40,
}
public static class User32
{
    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool MessageBeep(beepType uType);
}