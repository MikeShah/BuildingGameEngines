/// Run with: 'dub'

import sdl_abstraction;
import bindbc.sdl;
// Import D standard libraries
import std.stdio;
import std.string;


// Entry point to program
void main()
{
    // Create an SDL window
    SDL_Window* window= SDL_CreateWindow("D SDL Image Example",
                                        640,
                                        480, 
                                        SDL_WINDOW_ALWAYS_ON_TOP);
    // Load the bitmap surface
    SDL_Surface* myTestImage   = SDL_LoadBMP("./assets/images/test.bmp");

		// Blit the surace (i.e. update the window with another surfaces pixels
		//                       by copying those pixels onto the window).
		SDL_BlitSurface(myTestImage,null,SDL_GetWindowSurface(window),null);
		// Update the window surface
		SDL_UpdateWindowSurface(window);
		// Delay program so we can see results
		SDL_Delay(5000);

    // Destroy our surface
    SDL_DestroySurface(myTestImage);

    // Destroy our window
    SDL_DestroyWindow(window);
}
