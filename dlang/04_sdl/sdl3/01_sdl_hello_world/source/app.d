/// @file: 01_sdl_dub_examples/01_sdl_hello_world/app.d
/// 
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
	SDL_Window* window = SDL_CreateWindow("Dlang SDL3 Window", 0,0, SDL_WINDOW_ALWAYS_ON_TOP);

	SDL_Delay(3000);
	
	SDL_DestroyWindow(window);
}
