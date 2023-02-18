// @ File ./3_SDL_Event_Loop/main.cpp

// On linux compile with:
// g++ -std=c++17 main.cpp -o prog -lSDL2

// C++ Standard Libraries
#include <iostream>

// Third-party library
#include <SDL2/SDL.h>

// Program entry point
int main(int argc, char* argv[]){

    // Setup the Video subsystem
    if(SDL_Init(SDL_INIT_VIDEO) < 0){
        std::cout << "SDL could not be initialized: " << std::endl;
        std::cout << "SDL Error: " << SDL_GetError()  << std::endl;
    }else{
        std::cout << "SDL video system is ready" << std::endl;
    }
    // Create a window
    SDL_Window* window = SDL_CreateWindow("First SDL Program", 
                            0, 0,
                            640 ,480, SDL_WINDOW_SHOWN);

    // @ File ./3_SDL_Event_Loop/main.cpp
    // Main Loop
    bool runGame = true;
    while(runGame){
        //  Storage for an SDL Event
        SDL_Event event;
        // SDL_PollEvent pops off any events that are queued up.
        // Thi loop will thus run until all events are handled.
        while(SDL_PollEvent(&event)){
            switch(event.type){
                case SDL_QUIT:
                    runGame = false;
                    break;
            }
        }
        // After our 'input' is handled, then we can 'update' the
        // game and 'render/draw'.
    }


    return 0;
}


