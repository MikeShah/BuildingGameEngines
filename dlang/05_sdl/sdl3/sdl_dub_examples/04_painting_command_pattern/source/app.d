/// Run with: 'dub'

// Import D standard libraries
import std.stdio;
import std.string;

// Load the SDL library
import bindbc.sdl;
import sdl_abstraction;

interface Command{
	int Execute();
	int Undo();
}

class SurfaceOperation : Command{
	SDL_Surface* mSurface;
	int mXPosition;
	int mYPosition;
	
	this(SDL_Surface* surface, int xPos, int yPos){
		mSurface = surface;
		mXPosition = xPos;
		mYPosition = yPos;
	}

	~this(){

	}

	/// Function for updating the pixels in a surface to a 'blue-ish' color.
	int Execute(){
		// When we modify pixels, we need to lock the surface first
		SDL_LockSurface(mSurface);
		// Make sure to unlock the mSurface when we are done.
		scope(exit) SDL_UnlockSurface(mSurface);

		// Retrieve the pixel arraay that we want to modify
		ubyte* pixelArray = cast(ubyte*)mSurface.pixels;
    writeln("pitch:",mSurface.pitch);
    writeln("(x,y): (",mXPosition,",",mYPosition,")");
    writeln("Write Pixel location:",mYPosition*mSurface.pitch + mXPosition);
    writeln("Write Pixel location:",mYPosition*mSurface.pitch + mXPosition+1);
    writeln("Write Pixel location:",mYPosition*mSurface.pitch + mXPosition+2);
    
		// Change the 'blue' component of the pixels
		pixelArray[mYPosition*mSurface.pitch + mXPosition*4+0] = 255;
			// Change the 'green' component of the pixels
		pixelArray[mYPosition*mSurface.pitch + mXPosition*4+1] = 128;
			// Change the 'red' component of the pixels
		pixelArray[mYPosition*mSurface.pitch + mXPosition*4+2] = 32;

		return 0;
	}

	int Undo(){
		// When we modify pixels, we need to lock the surface first
		SDL_LockSurface(mSurface);
		// Make sure to unlock the mSurface when we are done.
		scope(exit) SDL_UnlockSurface(mSurface);

		// Retrieve the pixel arraay that we want to modify
		ubyte* pixelArray = cast(ubyte*)mSurface.pixels;
		// Change the 'blue' component of the pixels
		pixelArray[mYPosition*mSurface.pitch + mXPosition*4+0] = 0;
			// Change the 'green' component of the pixels
		pixelArray[mYPosition*mSurface.pitch + mXPosition*4+1] = 0;
			// Change the 'red' component of the pixels
		pixelArray[mYPosition*mSurface.pitch + mXPosition*4+2] = 0;
		return 0;
	}
}



// Entry point to program
void main()
{
    // Create an SDL window
    SDL_Window* window= SDL_CreateWindow("D SDL Painting",
                                        640,
                                        480, 
                                        SDL_WINDOW_ALWAYS_ON_TOP);
    // Load the bitmap surface
    SDL_Surface* imgSurface = SDL_CreateSurface(640,480,SDL_PIXELFORMAT_RGBA8888);
    // Free the image at end of main function 
    scope(exit) {
			SDL_DestroySurface(imgSurface);
	}

	// Flag for determing if we are running the main application loop
	bool runApplication = true;
	// Flag for determining if we are 'drawing' (i.e. mouse has been pressed
	//                                                but not yet released)
	bool drawing = false;


	Command[] CommandQueue;

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
				drawing=true;
			}else if(e.type == SDL_EVENT_MOUSE_BUTTON_UP){
				drawing=false;
			}else if(e.type == SDL_EVENT_MOUSE_MOTION && drawing){
				// retrieve the position
				int xPos = cast(int)e.button.x;
				int yPos = cast(int)e.button.y;
				// Loop through and update specific pixels
				// NOTE: No bounds checking performed --
				//       think about how you might fix this :)
				int brushSize=4;
				for(int w=-brushSize; w < brushSize; w++){
					for(int h=-brushSize; h < brushSize; h++){
						// Create a new command
						auto command = new SurfaceOperation(imgSurface,xPos+w,yPos+h);
						// Append to the end of our queue
						CommandQueue ~= command;
						// Execute the last command
						CommandQueue[$-1].Execute();
					}
				}
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
