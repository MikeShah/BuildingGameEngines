import sdl_abstraction;
import bindbc.sdl;
import std.stdio;
import std.string;


/// Note: In your resource manager you may consider
///       storing a 'id' or otherwise using the 'filepath'
///       as the key
struct Music{
    // Constructor

    this(string filepath){
       writeln("Loading music file: ", filepath);
  	   mFilepath = filepath;   
       mMusic = Mix_LoadWAV(filepath.toStringz);
        if(mMusic is null){
            writeln("Loading failed of", mFilepath);
        }
    }
    // Destructor
    ~this(){
        Mix_FreeChunk(mMusic);
    }
    // PlaySound
    void PlayMusic(){
        if(Mix_PlayChannel(-1,mMusic,1)==-1){
            writeln("Cannot play music",mFilepath);
            writeln("Error: ",fromStringz(SDL_GetError()));
        }
    }
    // Stop the sound
    void PauseMusic(){
        Mix_PauseMusic();
    }
    // Set the volume
    void SetVolume(int volume){
    }

    private: // (private member variables)
             // Device the Sound will play on
             // NOTE: This could be moved to some configuration,
             //       i.e., a higher level 'AudioManager' class
    int id;
    Mix_Chunk* mMusic;

    // Properties of the Music File that was loaded
    string 				mFilepath;
}
