/// @file: /sdl_sound/app.d
import std.stdio, std.string;
import bindbc.sdl;

import sound;
import sdl_abstraction;


struct Sprite{

    SDL_Texture* mTexture;
    SDL_FRect    mRectangle;

    this(SDL_Renderer* renderer, string bitmapFilePath){
        SDL_Surface* mSurface = SDL_LoadBMP(bitmapFilePath.toStringz);
        mTexture = SDL_CreateTextureFromSurface(renderer,mSurface);
        SDL_DestroySurface(mSurface);
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
        SDL_RenderTexture(renderer,mTexture,null,&mRectangle);
    }
}

void main()
{

	SDL_InitFlags audioSubSystem = SDL_WasInit(SDL_INIT_AUDIO);
	writeln("Was Audio Subystem initialized? (0 if not, 'audio' if so):", audioSubSystem);

    SDL_Window* window = SDL_CreateWindow("Dlang SDL Window",640 ,480, SDL_WINDOW_ALWAYS_ON_TOP);

    // Create a hardware accelerated mRenderer
    SDL_Renderer* renderer = SDL_CreateRenderer(window, null);

    // Create our sprite
    Sprite mySprite = Sprite(renderer,"./assets/images/test.bmp");

    // Create our Sound
    Sound mySound = Sound("./assets/sounds/collide.wav");

    bool gameIsRunning=true;
    while(gameIsRunning){
        // Store an SDL Event
        SDL_Event event;
        while(SDL_PollEvent(&event)){
            if(event.type == SDL_EVENT_QUIT){
                writeln("Exit event triggered");
                gameIsRunning= false;
            }
            if(event.type == SDL_EVENT_KEY_DOWN){
				mySound.ResumeSound();
        		mySound.PlaySound();
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
