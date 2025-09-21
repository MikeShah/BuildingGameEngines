import sdl_abstraction;
import bindbc.sdl;
import std.stdio;
import std.string;

/// Note: In your resource manager you may consider
///       storing a 'id' or otherwise using the 'filepath'
///       as the key
struct Sound{

	string  mFilepath;
    int 	mID;

    // Properties of the Wave File that is loaded
    SDL_AudioStream* mStream;
    SDL_AudioSpec mAudioSpec;
    ubyte*        mWaveData;
    uint          mWaveDataLength;

    // Constructor
    this(string filepath){
  		mFilepath = filepath;   
	   	if(!SDL_LoadWAV(filepath.toStringz,&mAudioSpec, &mWaveData, &mWaveDataLength)){
            writeln("sound loading error: ",SDL_GetError());
        }else{
            writeln("Sound file loaded:",filepath);
			// Convert .wav to whatever hardware wants
			mStream = SDL_OpenAudioDeviceStream(SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK, &mAudioSpec, null, null);
        }
    }
    // Destructor
    ~this(){
//        SDL_FreeWAV(m_waveStart);
//        SDL_CloseAudioDevice(m_device);
    }
	void ResumeSound(){
		// Sound needs to be 'resumed'. By default, sounds are
		// otherwise not 'playing'
		SDL_ResumeAudioStreamDevice(mStream);
	}

    // PlaySound
    void PlaySound(){
        // Queue the audio (so we play when available,
        //                  as oppososed to a callback function)
        if(SDL_GetAudioStreamQueued(mStream) < cast(int)mWaveDataLength){
			SDL_PutAudioStreamData(mStream,mWaveData,mWaveDataLength);	
		}

    }
    // Stop the sound
    void StopSound(){
//        SDL_PauseAudioDevice(m_device,1);
    }
    // Specific to SDL_Audio API

    void SetupDevice(){
        // Request the most reasonable default device
        // Set the device for playback for 0, or '1' for recording.
 //       m_device = SDL_OpenAudioDevice(null, 0, &m_audioSpec, null, SDL_AUDIO_ALLOW_ANY_CHANGE);
        // Error message if no suitable device is found to play
        // audio on.
  //      if(0 == m_device){
  //          writeln("sound device error: ",SDL_GetError()); 
  //      }
    }
}
