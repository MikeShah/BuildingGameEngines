/// @file: sdl_abstraction.d
// Load the SDL2 library
module sdl_abstraction;

import std.stdio;
import std.conv;
import std.string;
import core.stdc.stdlib;

import bindbc.sdl;
import loader = bindbc.loader.sharedlib;

// global variable for sdl;
const SDLSupport ret;
const SDLMixerSupport mixer_ret;

/// At the module level we perform any initialization before our program
/// executes. Effectively, what I want to do here is make sure that the SDL
/// library successfully initializes.
shared static this(){
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
        // Load the sound mixer
        mixer_ret = loadSDLMixer("SDL2_mixer.dll");
    }
    version(OSX){
        writeln("Searching for SDL on Mac");
        ret = loadSDL();
        mixer_ret = loadSDLMixer();
    }
    version(linux){ 
        writeln("Searching for SDL on Linux");
        ret = loadSDL();
        mixer_ret = loadSDLMixer();
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

    if(ret == sdlSupport){
        SDL_version sdlversion;
        SDL_GetVersion(&sdlversion);
        writeln(sdlversion);
        string msg = "Your SDL version loaded was: "~
            to!string(sdlversion.major)~"."~
            to!string(sdlversion.minor)~"."~
            to!string(sdlversion.patch);
        writeln(msg);
        if(sdlversion.major==2){
            writeln("Note: If SDL2 was loaded, it *may* be compatible with SDL3 function calls, but some are different.");
        }
    }


    writeln("SDL Mixer Version loaded");
    writeln("SDL_Mixer: "~Mix_Linked_Version().major.to!string~"."~
                          Mix_Linked_Version().minor.to!string~"."~
                          Mix_Linked_Version().patch.to!string
            );

    if (mixer_ret == SDLMixerSupport.noLibrary)
    {
        writeln("noLibrary error loading SDL_mixer library");
        foreach (info; loader.errors)
        {
            writeln(info.error, ':', info.message);
        }
    }
    if (mixer_ret == SDLMixerSupport.badLibrary)
    {
        writeln("Eror badLibrary, missing symbols, perhaps an older or very new version of SDL_mixer is causing the problem?");
    }

    // Initialize SDL
    if(SDL_Init(SDL_INIT_EVERYTHING) !=0){
        writeln("SDL_Init: ", fromStringz(SDL_GetError()));
    }

    // Example initializing MP3 files to be played as sounds
    // NOTE: You can add additional flags here as you need
    if(0==Mix_Init(1)){
        writeln("Mix_init failed");
        exit(0);
    }
    // Initialize SDL_Mixer
    if(Mix_OpenAudio(44_100,MIX_DEFAULT_FORMAT,2,2048) == -1){
        writeln("Mix loading error: ",Mix_GetError());
    }

}

/// At the module level, when we terminate, we make sure to 
/// terminate SDL, which is initialized at the start of the application.
shared static ~this(){
    // Quit the SDL Application 
    SDL_Quit();
    writeln("Shutting Down SDL");
}
