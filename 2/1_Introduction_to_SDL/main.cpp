// @ File 1_Introduction_to_SDL/main.cpp

// On linux compile with:
// g++ -std=c++17 main.cpp -o prog -lSDL2

// C++ Standard Libraries
#include <iostream>

// Third-party library
#include <SDL2/SDL.h>

int main(int argc, char* argv[]){

    // Setup the Video subsystem
    SDL_Init(SDL_INIT_VIDEO);

    // Create a window
    SDL_CreateWindow("First SDL Program", 
                    0,
                    0,
                    640,
                    480, 
                    SDL_WINDOW_SHOWN);

    // Create a delay (3000ms) so you can see your program show up
    SDL_Delay(3000);

    return 0;
}
