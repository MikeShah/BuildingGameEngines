// @ File ./7_BlitSurface/main.cpp

// On linux compile with:
// g++ -std=c++17 main.cpp -o prog -lSDL2

// C++ Standard Libraries
#include <iostream>

// Third-party library
#include <SDL2/SDL.h>

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
    SDL_Window* window = SDL_CreateWindow("4850/5850 SDL Program", 
                            0,
                            0,
                            640,
                            480, 
                            SDL_WINDOW_SHOWN);

// @ File ./7_BlitSurface/main.cpp
    // Get the window surface
    SDL_Surface* windowSurface = SDL_GetWindowSurface(window);
    // Load a test image
    SDL_Surface* myTestImage = SDL_LoadBMP("./assets/images/test.bmp");
    // 'Blit' or 'copy' the image to the window surface
    // Note: NULL means to copy the whole image to the whole surface.
    //       src -> destination
    // Note: The test image is 460x460 pixels, thus not filling the
    //       entire screen
    SDL_BlitSurface(myTestImage, NULL, windowSurface, NULL);
    // Free our test iamge now that we're done
    SDL_FreeSurface (myTestImage);
    // Update the window surface
    // This effectively 'refreshes our screen'
    SDL_UpdateWindowSurface(window);
    // Create a delay (3000ms) so you can see your program show up
    SDL_Delay(3000);

    return 0;
}


