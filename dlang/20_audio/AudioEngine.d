// @file AudioEngine.d

struct AudioEngine{

    static void Init(){}
    static void Update(){}
    static void Shutdown(){}

    void Set3DListenderAndOrientation(const Vec3 vPosition, const Vec3 vLook, const Vec3 vUp){}
    int PlaySound(const string strSoundName, const Vec3 vPos, float fVolumeDB){ return 0;}
    int StopChannel(int nChannelId){ return 0;}
    int StopAllChannels(){ return 0;}
    void SetChannel3DPosition(int nChannelId, const Vec3 vPosition){}
    void SetChannelVolume(int nChannelId, float fVolumeDB){}
    bool IsPlaying(int nChannelID){return false;}

    // Could be part of resource manager.
    // In some cases, 'AudioEngine' may also otherwise be its own Singleton Class
    void LoadSound(const string strSoundName, bool b3d=true, bool bLooping=false, bool bStream=false){}
    void UnLoadSound(const string strSoundName){}
}

struct Vec3{float x,y,z;}

void main(){}
