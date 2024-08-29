// @ File ./2_SDL_Window/main.cpp

// On linux compile with:
// g++ -std=c++17 main.cpp -o prog -lSDL2

// C++ Standard Libraries
#include <iostream>

// Third-party library
#include <SDL2/SDL.h>

// @ File ./2_SDL_Window/main.cpp
int main(int argc, char* argv[]){

    // Setup the Video subsystem
    // We'll handle any errors if this function returns less than
    // 0.
    if(SDL_Init(SDL_INIT_VIDEO) < 0){
        std::cout << "SDL could not be initialized: " << std::endl;
        std::cout << "SDL Error: " << SDL_GetError()  << std::endl;
    }else{
        std::cout << "SDL video system is ready" << std::endl;
    }
    // Create a window
    // Store a handle to this window in a pointer.
    // Then we can pass this pointer to various window handling
    // functions
    SDL_Window* window = SDL_CreateWindow("First SDL Program", 
                            0,
                            0,
                            640,
                            480, 
                            SDL_WINDOW_SHOWN);
    // Create a delay (3000ms) so you can see your program show up
    SDL_Delay(3000);

    return 0;
}


