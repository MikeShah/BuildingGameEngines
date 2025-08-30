/// Run with: 'dub'

// Import D standard libraries
import std.stdio;
import std.string;

// Load the SDL library
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
    // Load the bitmap surface
    SDL_Surface* imgSurface = SDL_CreateSurface(640,480,SDL_PIXELFORMAT_RGBA8888);
    // Free the image
    scope(exit) {
			SDL_DestroySurface(imgSurface);
		}

		// Flag for determing if we are running the main application loop
		bool runApplication = true;

		// boolean for telling us if mouse is up or down
		bool drawing = false;
		// Main application loop that will run until a quit event has occurred.
		// This is the 'main graphics loop'
	while(runApplication){
		SDL_Event e;
		// Handle events
		// Events are pushed into an 'event queue' internally in SDL, and then
		// handled one at a time within this loop for as many events have
		// been pushed into the internal SDL queue. Thus, we poll until there
		// are '0' events or a NULL event is returned.
		while(SDL_PollEvent(&e) !=0){
			if(e.type == SDL_EVENT_QUIT){
				runApplication= false;
			}
			else if(e.type == SDL_EVENT_MOUSE_BUTTON_DOWN){
				writeln("Mouse Pressed");
				drawing = true;
			}else if(e.type == SDL_EVENT_MOUSE_BUTTON_UP){
				writeln("Mouse Released");
				drawing = false;
			}else if(e.type == SDL_EVENT_MOUSE_MOTION && drawing){
				// retrieve the position
				int xPos = cast(int)e.button.x;
				int yPos = cast(int)e.button.y;
				// When we modify pixels, we need to lock the surface first
				SDL_LockSurface(imgSurface);
				// Make sure to unlock the mSurface when we are done.
				scope(exit) SDL_UnlockSurface(imgSurface);
				// Retrieve the pixel arraay that we want to modify
				ubyte* pixelArray = cast(ubyte*)imgSurface.pixels;
				// Change the 'blue' component of the pixels
				pixelArray[yPos*imgSurface.pitch + xPos*4+0] = 255;
				// Change the 'green' component of the pixels
				pixelArray[yPos*imgSurface.pitch + xPos*4+1] = 128;
				// Change the 'red' component of the pixels
				pixelArray[yPos*imgSurface.pitch + xPos*4+2] = 32;
			}
		}

		// Blit the surace (i.e. update the window with another surfaces pixels
		//                       by copying those pixels onto the window).
		SDL_BlitSurface(imgSurface,null,SDL_GetWindowSurface(window),null);
		// Update the window surface
		SDL_UpdateWindowSurface(window);
		// Delay for 16 milliseconds
		// Otherwise the program refreshes too quickly
		SDL_Delay(16);
	}

    // Destroy our window
    SDL_DestroyWindow(window);
}
