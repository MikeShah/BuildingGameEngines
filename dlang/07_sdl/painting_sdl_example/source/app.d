/// Run with: 'dub'

// Import D standard libraries
import std.stdio;
import std.string;

// Load the SDL2 library
import bindbc.sdl;
import loader = bindbc.loader.sharedlib;

// global variable for sdl;
const SDLSupport ret;

/// At the module level we perform any initialization before our program
/// executes. Effectively, what I want to do here is make sure that the SDL
/// library successfully initializes.
shared static this(){
		// Load the SDL libraries from bindbc-sdl
		// on the appropriate operating system
    version(Windows){
    		writeln("Searching for SDL on Windows");
				ret = loadSDL("SDL2.dll");
		}
  	version(OSX){
      	writeln("Searching for SDL on Mac");
        ret = loadSDL();
    }
    version(linux){ 
      	writeln("Searching for SDL on Linux");
				ret = loadSDL();
		}

		// Error if SDL cannot be loaded
    if(ret != sdlSupport){
        writeln("error loading SDL library");    
        foreach( info; loader.errors){
            writeln(info.error,':', info.message);
        }
    }
    if(ret == SDLSupport.noLibrary){
        writeln("error no library found");    
    }
    if(ret == SDLSupport.badLibrary){
        writeln("Eror badLibrary, missing symbols, perhaps an older or very new version of SDL is causing the problem?");
    }

    // Initialize SDL
    if(SDL_Init(SDL_INIT_EVERYTHING) !=0){
        writeln("SDL_Init: ", fromStringz(SDL_GetError()));
    }
}

/// At the module level, when we terminate, we make sure to 
/// terminate SDL, which is initialized at the start of the application.
shared static ~this(){
    // Quit the SDL Application 
    SDL_Quit();
		writeln("Ending application--good bye!");
}




// Entry point to program
void main()
{
    // Create an SDL window
    SDL_Window* window= SDL_CreateWindow("D SDL Image Example",
                                        SDL_WINDOWPOS_UNDEFINED,
                                        SDL_WINDOWPOS_UNDEFINED,
                                        640,
                                        480, 
                                        SDL_WINDOW_SHOWN);
    // Load the bitmap surface
    SDL_Surface* imgSurface = SDL_CreateRGBSurface(0,640,480,32,0,0,0,0);
    // Free the image
    scope(exit) {
			SDL_FreeSurface(imgSurface);
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
			if(e.type == SDL_QUIT){
				runApplication= false;
			}
			else if(e.type == SDL_MOUSEBUTTONDOWN){
				writeln("Mouse Pressed");
				drawing = true;
			}else if(e.type == SDL_MOUSEBUTTONUP){
				writeln("Mouse Released");
				drawing = false;
			}else if(e.type == SDL_MOUSEMOTION && drawing){
				// retrieve the position
				int xPos = e.button.x;
				int yPos = e.button.y;
				// When we modify pixels, we need to lock the surface first
				SDL_LockSurface(imgSurface);
				// Make sure to unlock the mSurface when we are done.
				scope(exit) SDL_UnlockSurface(imgSurface);
				// Retrieve the pixel arraay that we want to modify
				ubyte* pixelArray = cast(ubyte*)imgSurface.pixels;
				// Change the 'blue' component of the pixels
				pixelArray[yPos*imgSurface.pitch + xPos*imgSurface.format.BytesPerPixel+0] = 255;
				// Change the 'green' component of the pixels
				pixelArray[yPos*imgSurface.pitch + xPos*imgSurface.format.BytesPerPixel+1] = 128;
				// Change the 'red' component of the pixels
				pixelArray[yPos*imgSurface.pitch + xPos*imgSurface.format.BytesPerPixel+2] = 32;
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
