/// Run with: 'dub'

// Import D standard libraries
import std.stdio;
import std.string;

// Load the SDL2 library
import bindbc.sdl;
import sdl_abstraction;

// Entry point to program
bool RunSDL(immutable string[] args)
{
  static instantiated = false;
  static SDL_Window* window;
  static SDL_Surface* imgSurface;

  if(instantiated == false){
    // Create an SDL window
    window= SDL_CreateWindow("D SDL Painting",
        640,
        480, 
        SDL_WINDOW_ALWAYS_ON_TOP);

    // Load the bitmap surface
    imgSurface = SDL_CreateSurface(640,480,SDL_PIXELFORMAT_RGBA8888);
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
      if(e.type == SDL_EVENT_QUIT){
        runApplication= false;
      }
      else if(e.type == SDL_EVENT_MOUSE_BUTTON_DOWN){
        writeln("Mouse down in SDL event loop");
      }else if(e.type == SDL_EVENT_MOUSE_BUTTON_UP){
        writeln("Mouse up in SDL event loop");
      }else if(e.type == SDL_EVENT_MOUSE_MOTION){
        // retrieve the position
        float xPos = e.button.x;
        float yPos = e.button.y;
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

