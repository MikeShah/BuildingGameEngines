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
		// Create a hardware accelerated renderer
		SDL_Renderer* renderer = null;
		renderer = SDL_CreateRenderer(window,-1,SDL_RENDERER_ACCELERATED);


    // Load the bitmap surface
    SDL_Surface* myTestImage   = SDL_LoadBMP("./assets/images/test.bmp");
		// Create a texture from the surface
		SDL_Texture* texture = SDL_CreateTextureFromSurface(renderer,myTestImage);
		// Done with the bitmap surface pixels after we create the texture, we have
		// effectively updated memory to GPU texture.
		SDL_FreeSurface(myTestImage);

		// Rectangle is where we will represent the shape
		SDL_Rect rectangle;
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
            if(event.type == SDL_QUIT){
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
//        SDL_SetRenderDrawColor(renderer,255,255,255,SDL_ALPHA_OPAQUE);
//        SDL_RenderDrawLine(renderer,5,5,100,120);

				// Draw our shape
        SDL_RenderCopy(renderer,texture,null,&rectangle);

        // Finally show what we've drawn
        SDL_RenderPresent(renderer);

    }


    // Destroy our window
    SDL_DestroyWindow(window);
}
