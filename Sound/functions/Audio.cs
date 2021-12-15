using System.Runtime.InteropServices;

namespace Audio {
    [Guid("5CDF2C82-841E-4546-9722-0CF74078229A"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    interface IAudioEndpointVolume {
        int RegisterControlChangeNotify();
        int UnregisterControlChangeNotify();
        int GetChannelCount();
        int SetMasterVolumeLevel();
        int SetMasterVolumeLevelScalar(float fLevel, System.Guid pguidEventContext);
        int GetMasterVolumeLevel();
        int GetMasterVolumeLevelScalar(out float pfLevel);
        int SetChannelVolumeLevel();
        int SetChannelVolumeLevelScalar();
        int GetChannelVolumeLevel();
        int GetChannelVolumeLevelScalar();
        int SetMute([MarshalAs(UnmanagedType.Bool)] bool bMute, System.Guid pguidEventContext);
        int GetMute(out bool pbMute);
    }
    [Guid("D666063F-1587-4E43-81F1-B948E807363F"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    interface IMMDevice {
        int Activate(ref System.Guid id, int clsCtx, int activationParams, out IAudioEndpointVolume aev);
    }
    [Guid("A95664D2-9614-4F35-A746-DE8DB63617E6"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    interface IMMDeviceEnumerator {
        int EnumAudioEndpoints();
        int GetDefaultAudioEndpoint(int dataFlow, int role, out IMMDevice endpoint);
    }
    [ComImport, Guid("BCDE0395-E52F-467C-8E3D-C4579291692E")] class _MMDeviceEnumrator { }
    public class Sound {
        static IAudioEndpointVolume Vol() {
            IMMDevice _realDevice = null;
            IAudioEndpointVolume _realEndpoint = null;
            var _realEnumrator = new _MMDeviceEnumrator() as IMMDeviceEnumerator;
            var epvid = typeof(IAudioEndpointVolume).GUID;
            Marshal.ThrowExceptionForHR(_realEnumrator.GetDefaultAudioEndpoint(0, 1, out _realDevice));
            Marshal.ThrowExceptionForHR(_realDevice.Activate(ref epvid, 23, 0, out _realEndpoint));
            return _realEndpoint;
        }
        public static bool Mute {
            get { bool mute; Marshal.ThrowExceptionForHR(Vol().GetMute(out mute)); return mute; }
            set { Marshal.ThrowExceptionForHR(Vol().SetMute(value, System.Guid.Empty)); }
        }
        public static float Volume {
            get {float v = -1; Marshal.ThrowExceptionForHR(Vol().GetMasterVolumeLevelScalar(out v)); return v;}
            set {Marshal.ThrowExceptionForHR(Vol().SetMasterVolumeLevelScalar(value, System.Guid.Empty));}
        }
    }
}
