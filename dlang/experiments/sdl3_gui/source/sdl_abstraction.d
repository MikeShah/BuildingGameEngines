/// @file: sdl_abstraction.d
// Load the SDL3 library
module sdl_abstraction;

import std.stdio;
import std.string;

import bindbc.sdl;
import bindbc.loader.sharedlib;
import loader=bindbc.loader.sharedlib;

/// At the module level we perform any initialization before our program
/// executes. Effectively, what I want to do here is make sure that the SDL
/// library successfully initializes.
shared static this(){
	// global variable for sdl;
	loader.LoadMsg ret;
	// Load the SDL libraries from bindbc-sdl
	// on the appropriate operating system
	version(Windows){
		writeln("Searching for SDL on Windows");
		// NOTE: Windows folks I've defaulted into SDL3, but
		// 			 will fallback to try to find SDL2 otherwise.
		ret = loadSDL("SDL3.dll");
		if(ret != sdlSupport){
			writeln("Falling back on Windows to find SDL2.dll");
			ret = loadSDL("SDL2.dll");
		}
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
	if(ret != LoadMsg.success){
		writeln("error loading SDL library");    
		foreach( info; loader.errors){
			writeln(info.error,':', info.message);
		}
	}
	if(ret == LoadMsg.noLibrary){
		writeln("error no library found");    
	}
	if(ret == LoadMsg.badLibrary){
		writeln("Eror badLibrary, missing symbols, perhaps an older or very new version of SDL is causing the problem?");
	}

	if(ret == LoadMsg.success){
		import std.conv;
		int sdlversion = SDL_GetVersion();
		string msg = "Your SDL version("~sdlversion.to!string~") loaded was: "~
			to!string(SDL_VERSIONNUM_MAJOR(sdlversion))~"."~
			to!string(SDL_VERSIONNUM_MINOR(sdlversion))~"."~
			to!string(SDL_VERSIONNUM_MICRO(sdlversion));
		writeln(msg);
		if(SDL_VERSIONNUM_MAJOR(sdlversion)==2){
			writeln("Note: We are expecting SDL version 3, and found SDL2 on your system. Please install SDL3");
		}
	}
	// Initialize SDL
	SDL_InitFlags flags = SDL_INIT_VIDEO | SDL_INIT_EVENTS;
	if(SDL_Init(flags)){
		writeln("SDL initialized with flags: ",flags);
	}else{
		writeln("SDL_Init errors:", fromStringz(SDL_GetError()));
	}

}

/// At the module level, when we terminate, we make sure to 
/// terminate SDL, which is initialized at the start of the application.
shared static ~this(){
	// Quit the SDL Application 
	SDL_Quit();
	writeln("Shutting Down SDL");
}
