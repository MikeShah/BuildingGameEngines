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


class Widget{

}


class Button : Widget{
    // Rectangle is where we will represent the shape
    SDL_Rect mRectangle;
    SDL_Texture* mFontTexture;
    char[] mText;

    this(char[] label,int x, int y, int w, int h){
		mRectangle.x = x;
		mRectangle.y = y;
		mRectangle.w = w;
		mRectangle.h = h;
        mText = label.dup;
    }

    void Render(SDL_Renderer* renderer){ 
        // NOTE: Probably better to abstract this elsewhere
        //       I put the code here for simplicity of the demo
        if(mFontTexture==null){
            // Load the bitmap surface
            // NOTE: You should only load this resource once.
            //       This is really inefficient to reload constantly, so this is just a demo!
            SDL_Surface* img = SDL_LoadBMP("./assets/font.bmp");
            // Create a texture from the surface
            mFontTexture = SDL_CreateTextureFromSurface(renderer,img);
            // Done with the bitmap surface pixels after we create the texture, we have
            // effectively updated memory to GPU texture.
            SDL_FreeSurface(img);
        }
        // Draw our button
        SDL_SetRenderDrawColor(renderer,100,190,255,SDL_ALPHA_OPAQUE);
        SDL_RenderDrawRect(renderer,&mRectangle);

        // Handle tet drawing
        // For each character, sample in correct position in texture and paste in text
        foreach(int idx,c ; mText){
            // Next position to draw to
            SDL_Rect display;
            display.x = mRectangle.x + 16*idx;
            display.y = mRectangle.y;
            display.w = 16;
            display.h = 16;
    
            // Select correct portion of texture
            SDL_Rect select;
            // Note: Need to offset ASCII character to appropriate position in font
            //       This may vary based on your image.
            //       You'll also likely want 'empty' spaces and other chracters.
            int value = cast(int)c - 65;
            select.x = value * 16;
            select.y = 0;
            select.w = 16;
            select.h = 16;
            
            SDL_RenderCopy(renderer,mFontTexture,&select,&display);
        }
    }

}


// Entry point to program
void main()
{
    // Create an SDL window
    SDL_Window* window= SDL_CreateWindow("D SDL Bitmap Font",
                                        SDL_WINDOWPOS_UNDEFINED,
                                        SDL_WINDOWPOS_UNDEFINED,
                                        640,
                                        480, 
                                        SDL_WINDOW_SHOWN);
	// Create a hardware accelerated renderer
	SDL_Renderer* renderer = null;
	renderer = SDL_CreateRenderer(window,-1,SDL_RENDERER_ACCELERATED);


    auto myButton = new Button(cast(char[])"MIKE",30,30,100,100);

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
        SDL_SetRenderDrawColor(renderer,32,32,32,SDL_ALPHA_OPAQUE);
        SDL_RenderClear(renderer);

        // Do our drawing
        myButton.Render(renderer);


        // Finally show what we've drawn
        SDL_RenderPresent(renderer);

    }


    // Destroy our window
    SDL_DestroyWindow(window);
}
