/// @file: /sdl_sound/app.d
import std.stdio;
import sdl_abstraction;
import bindbc.sdl;
import std.string;

struct Sound{
    // Constructor
    this(string filepath){
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
    SDL_AudioSpec m_audioSpec;
    ubyte*        m_waveStart;
    uint          m_waveLength;
}

struct Sprite{

    SDL_Texture* mTexture;
    SDL_Rect     mRectangle;

    this(SDL_Renderer* renderer, string bitmapFilePath){
        SDL_Surface* mSurface = SDL_LoadBMP(bitmapFilePath.toStringz);
        mTexture = SDL_CreateTextureFromSurface(renderer,mSurface);
        SDL_FreeSurface(mSurface);
        // Position the rectangle 
        mRectangle.x = 50;
        mRectangle.y = 50;
        mRectangle.w = 100;
        mRectangle.h = 100;
    }

    // Destroy anything 'heap' allocated.
    // Remember, SDL is a C library, thus heap allocated resources need
    // to be destroyed
    ~this(){
        SDL_DestroyTexture(mTexture);
    }

    void Input(){}
    void Update(){}

    void Render(SDL_Renderer* renderer){
        // Copy a texture (or portion of a texture) to another
        // portion of video memory (i.e. a 2D grid of texels 
        // which span the width and height of the window)
        SDL_RenderCopy(renderer,mTexture,null,&mRectangle);
    }
}

void main()
{
    SDL_Window* window = SDL_CreateWindow("Dlang SDL Window",
            0,0, 640,480, SDL_WINDOW_SHOWN);

    // Create a hardware accelerated mRenderer
    SDL_Renderer* renderer = SDL_CreateRenderer(window,-1,SDL_RENDERER_ACCELERATED);

    // Create our sprite
    Sprite mySprite = Sprite(renderer,"./assets/images/test.bmp");

    // Create our Sound
    Sound mySound = Sound("./assets/sounds/collide.wav");
    mySound.SetupDevice();
        mySound.PlaySound();

    bool gameIsRunning=true;
    while(gameIsRunning){
        // Store an SDL Event
        SDL_Event event;
        while(SDL_PollEvent(&event)){
            if(event.type == SDL_QUIT){
                writeln("Exit event triggered");
                gameIsRunning= false;
            }
            if(event.type == SDL_KEYDOWN){
                writeln("Pressed a key ");
            }
        }

        // Update our sprite
        mySprite.Update();

        // Set the render draw color 
        SDL_SetRenderDrawColor(renderer,100,190,255,SDL_ALPHA_OPAQUE);
        // Clear the renderer each time we render
        SDL_RenderClear(renderer);

        mySprite.Render(renderer);

        // Final step is to present what we have copied into
        // video memory
        SDL_RenderPresent(renderer);
    }
    // Destroy our renderer
    SDL_DestroyRenderer(renderer);
    // Destroy our window
    SDL_DestroyWindow(window);
} // end main()
