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
bool RunSDL(immutable string[] args)
{
    static instantiated = false;
    static SDL_Window* window;
    static SDL_Surface* imgSurface;

    if(instantiated == false){
        // Create an SDL window
        window= SDL_CreateWindow("D SDL Painting",
                                            SDL_WINDOWPOS_UNDEFINED,
                                            SDL_WINDOWPOS_UNDEFINED,
                                            640,
                                            480, 
                                            SDL_WINDOW_SHOWN);
        // Load the bitmap surface
        imgSurface = SDL_CreateRGBSurface(0,640,480,32,0,0,0,0);
        // Important to flip the flag to true so we
        // only instantiate once
        instantiated = true;
    }

	// Flag for determing if we are running the main application loop
	static bool runApplication = true;

	// Main application loop that will run until a quit event has occurred.
	// This is the 'main graphics loop'
	if(runApplication){
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
                writeln("Mouse down in SDL event loop");
			}else if(e.type == SDL_MOUSEBUTTONUP){
                writeln("Mouse up in SDL event loop");
			}else if(e.type == SDL_MOUSEMOTION){
				// retrieve the position
				int xPos = e.button.x;
				int yPos = e.button.y;
                writeln("sdl mouse: ", xPos,",",yPos);
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
        writeln("SDL 'idle loop'");
	}

    // Destroy our window
    // NOTE: Should go into module destructor
//    SDL_DestroyWindow(window);

    return true;
}

