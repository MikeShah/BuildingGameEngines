import sdl_abstraction;
import bindbc.sdl;
import std.stdio;
import std.string;

/// Note: In your resource manager you may consider
///       storing a 'id' or otherwise using the 'filepath'
///       as the key
struct Sound{
    // Constructor

    this(string filepath){
  		mFilepath = filepath;   
	   if(SDL_LoadWAV(filepath.toStringz,&m_audioSpec, &m_waveStart, &m_waveLength) == null){
            writeln("sound loading error: ",SDL_GetError());
        }else{
            writeln("Sound file loaded:",filepath);
        }
    }
    // Destructor
    ~this(){
        SDL_FreeWAV(m_waveStart);
        SDL_CloseAudioDevice(m_device);
    }
    // PlaySound
    void PlaySound(){
        // Queue the audio (so we play when available,
        //                  as oppososed to a callback function)
        int status = SDL_QueueAudio(m_device, m_waveStart, m_waveLength);
        SDL_PauseAudioDevice(m_device,0);
    }
    // Stop the sound
    void StopSound(){
        SDL_PauseAudioDevice(m_device,1);
    }
    // Specific to SDL_Audio API

    void SetupDevice(){
        // Request the most reasonable default device
        // Set the device for playback for 0, or '1' for recording.
        m_device = SDL_OpenAudioDevice(null, 0, &m_audioSpec, null, SDL_AUDIO_ALLOW_ANY_CHANGE);
        // Error message if no suitable device is found to play
        // audio on.
        if(0 == m_device){
            writeln("sound device error: ",SDL_GetError()); 
        }
    }

    private: // (private member variables)
             // Device the Sound will play on
             // NOTE: This could be moved to some configuration,
             //       i.e., a higher level 'AudioManager' class
    int id;
    SDL_AudioDeviceID m_device;

    // Properties of the Wave File that is loaded
		string 				mFilepath;
    SDL_AudioSpec m_audioSpec;
    ubyte*        m_waveStart;
    uint          m_waveLength;
}
