// For this example I am first showing you how to
// compile the SDL library with C.
// While this repository has a lot of D code, it is
// useful to test with this code otherwise to make
// sure that SDL is properly configured.
//
//
//
// On linux compile with:
// gcc sdl_main.c -o prog -lSDL3

// C Standard Libraries
#include <stdio.h>
// Third-party library
#include <SDL3/SDL.h>

int main(int argc, char* argv[]){

    // Create a window data type
    // This pointer will point to the 
    // window that is allocated from SDL_CreateWindow
    SDL_Window* window=NULL;

    // Initialize the video subsystem.
    // If it returns less than 1, then an
    // error code will be received.
    if(SDL_Init(SDL_INIT_VIDEO) < 0){
        printf("SDL could not be initialized: %s",SDL_GetError());
    }else{
        printf("SDL video system is ready to go\n");
    }

    // Request a window to be created for our platform
    // The parameters are for the title and the width and height of the window.
		window = SDL_CreateWindow("A C SDL3 Window",800,600,SDL_WINDOW_ALWAYS_ON_TOP);

    // We add a delay in order to see that our window
    // has successfully popped up.
    SDL_Delay(3000);

    // We destroy our window. We are passing in the pointer
    // that points to the memory allocated by the 
    // 'SDL_CreateWindow' function. Remember, this is
    // a 'C-style' API, we don't have destructors.
    SDL_DestroyWindow(window);
    
    // We safely uninitialize SDL2, that is, we are
    // taking down the subsystems here before we exit
    // our program.
    SDL_Quit();

    return 0;
}
