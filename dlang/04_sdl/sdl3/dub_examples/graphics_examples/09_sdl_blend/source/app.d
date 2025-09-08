/// @file: sdl_dub_examples/06_sdl_sprite/app.d
import std.stdio;
import sdl_abstraction;
import bindbc.sdl;
import sprite;

void main()
{
    SDL_Window* window = SDL_CreateWindow("Dlang SDL Window",640,480, SDL_WINDOW_ALWAYS_ON_TOP);

    // Create a hardware accelerated mRenderer
    SDL_Renderer* renderer = SDL_CreateRenderer(window,null);

    Sprite mySprite = Sprite(renderer,"./assets/images/test.bmp");
    Sprite mySprite2 = Sprite(renderer,"./assets/images/test.bmp");

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
                writeln("Pressed a key ");
            }
        }

        static x = 0;
        static xDir = 1;
        if(x>540){xDir = -1;}
        if(x<0){xDir = 1;}
        if(xDir>0){x+=2;}
        if(xDir<0){x-=2;}

        mySprite2.Move(x,50);

        // Update our sprite
        mySprite.Update();
        mySprite2.Update();

        // Slow down the application for the purpose of this demo
        SDL_Delay(16);  

        // Set the render draw color 
        SDL_SetRenderDrawColor(renderer,100,190,255,SDL_ALPHA_OPAQUE);
        // Clear the renderer each time we render
        SDL_RenderClear(renderer);

        mySprite.Render(renderer,  SDL_BLENDMODE_BLEND);
        mySprite2.Render(renderer, SDL_BLENDMODE_MOD);

        // Final step is to present what we have copied into
        // video memory
        SDL_RenderPresent(renderer);
    }
    // Destroy our renderer
    SDL_DestroyRenderer(renderer);
    // Destroy our window
    SDL_DestroyWindow(window);
} // end main()
