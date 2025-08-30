/// @file: sdl_dub_examples/03_sdl_event_loop/app.d
/// 
import std.stdio;
/// Run with: 'dub' 'dub run'
/// On occasion, 'dub clean' followed by 'dub build' to do a rebuild.
/// 'dub test' will run your tests.
///
/// 'dub lint' can also be useful for style checking and best practices
/// usually using the dscanner tool. 

// Loads SDL Libraries
// NOTE: sdl_asbstraction currently runs 'SDL_Init' before main(), and
//       will run 'SDL_Quit' when the program terminates.
import sdl_abstraction;

// Third-party library which provides
// declarations of functions and structs in SDL
import bindbc.sdl;

// Entry point to program
void main()
{
	SDL_Window* window = SDL_CreateWindow("Dlang SDL3 Window", 320,240, SDL_WINDOW_ALWAYS_ON_TOP);

	bool gameIsRunning=true;
	while(gameIsRunning){
		// Store an SDL Event
		SDL_Event event;
		// SDL_PollEvent pops off any events that are queued up.
		// This loop will thus run until all events are handled.
		while(SDL_PollEvent(&event)){
			if(event.type == SDL_EVENT_QUIT){
				writeln("Exit event triggered");
				gameIsRunning= false;
			}
			writeln("event loop");
		}

		writeln("main game loop");
		// After we handle 'input' we can run the rest of the game here.

		// Update();
		// Render();
	}
	// Cleanup
	SDL_DestroyWindow(window);
} // end main()
