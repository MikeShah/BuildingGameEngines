/// Run with: 'dub'

// Import D standard libraries
import std.stdio;
import std.string;

// Load the SDL2 library
import bindbc.sdl;
import sdl_abstraction;
// Entry point to program
void main()
{
    // Create an SDL window
    SDL_Window* window= SDL_CreateWindow("D SDL Image Example",
                                        640,
                                        480, 
                                        SDL_WINDOW_ALWAYS_ON_TOP);
		// Create a hardware accelerated renderer
		SDL_Renderer* renderer = null;
		renderer = SDL_CreateRenderer(window,null);

    // Load the bitmap surface
    SDL_Surface* myTestImage   = SDL_LoadBMP("./assets/images/test.bmp");
		// Create a texture from the surface
		SDL_Texture* texture = SDL_CreateTextureFromSurface(renderer,myTestImage);
		// Done with the bitmap surface pixels after we create the texture, we have
		// effectively updated memory to GPU texture.
		SDL_DestroySurface(myTestImage);

		// Rectangle is where we will represent the shape
		SDL_FRect rectangle;
		rectangle.x = 50;
		rectangle.y = 50;
		rectangle.w = 100;
		rectangle.h = 100;

    // Infinite loop for our application
    bool gameIsRunning = true;
    // Main application loop
    while(gameIsRunning){
        SDL_Event event;

        // (1) Handle Input
        // Start our event loop
        while(SDL_PollEvent(&event)){
            // Handle each specific event
            if(event.type == SDL_EVENT_QUIT){
                gameIsRunning= false;
            }
        }
        // (2) Handle Updates

        // (3) Clear and Draw the Screen
        // Gives us a clear "canvas"
        SDL_SetRenderDrawColor(renderer,100,190,255,SDL_ALPHA_OPAQUE);
        SDL_RenderClear(renderer);

        // Do our drawing

				// Ucomment this to see a line drawn
				// may be useful for debugging!
        SDL_SetRenderDrawColor(renderer,255,255,255,SDL_ALPHA_OPAQUE);
        SDL_RenderLine(renderer,5,5,100,120);

				// Draw our shape
        SDL_RenderTexture(renderer,texture,null,&rectangle);

        // Finally show what we've drawn
        SDL_RenderPresent(renderer);

    }


    // Destroy our window
    SDL_DestroyWindow(window);
}
