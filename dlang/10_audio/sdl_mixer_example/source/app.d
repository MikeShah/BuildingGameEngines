/// @file: /sdl_sound/app.d
import sdl_abstraction;
import bindbc.sdl;
import std.string;
import std.stdio;
import sprite;
import music;

void main()
{
    SDL_Window* window = SDL_CreateWindow("Dlang SDL Window",
            0,0, 640,480, SDL_WINDOW_SHOWN);

    // Create a hardware accelerated mRenderer
    SDL_Renderer* renderer = SDL_CreateRenderer(window,-1,SDL_RENDERER_ACCELERATED);

    // Create our sprite
    Sprite mySprite = Sprite(renderer,"./assets/images/test.bmp");

    // Create our Sound
    Music myMusic = Music("./assets/music/guitarchords.mp3");
    //Music myMusic = Music("./assets/music/collide.wav");
    myMusic.PlayMusic();

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
