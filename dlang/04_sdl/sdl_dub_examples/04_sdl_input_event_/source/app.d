/// @file: sdl_dub_examples/04_sdl_input_event/app.d
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
		SDL_Window* window = SDL_CreateWindow("Dlang SDL Window",
						0,0, 640,480, SDL_WINDOW_SHOWN);

		bool gameIsRunning=true;
		while(gameIsRunning){
				// Store an SDL Event
				SDL_Event event;
				// SDL_Pollevent pops off any events that are queued up.
				// This loop will thus run until all events are handled.
				while(SDL_PollEvent(&event)){
						if(event.type == SDL_QUIT){
								writeln("Exit event triggered");
								gameIsRunning= false;
						}
						// SDL2: SDL_KEYDOWN
						//  - See gist for where I found 'SDL_KEYWOWN' https://github.com/libsdl-org/SDL/blob/1c4dd015ac28fa634024545f94a114c49a8d4acb/include/SDL_events.h#L98
						// SDL3: SDL_EVENT_KEY_DOWN
						//  - see gist for exact place where I found 'SDL_EVENT_KEY_DOWN' for sdl3
						// https://github.com/libsdl-org/SDL/blob/03ae792df35a15e80e16a41ea2cf19971fc8d8f6/include/SDL3/SDL_events.h#L144C5-L144C23
						if(event.type == SDL_KEYDOWN){
								writeln("Pressed a key ");
						}
				}
			
				// After we handle 'input' we can run the rest of the game here.

				// Update();
				// Render();
		}
} // end main()
