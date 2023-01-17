// @ File ./8_Hardware_Accelerated_Textures/main.cpp

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
// @ File ./8_Hardware_Accelerated_Textures/main.cpp
    // Create a window
    // Store a handle to this window in a pointer.
    // Then we can pass this pointer to various window handling
    // functions
    SDL_Window* window  = SDL_CreateWindow("4850/5850 SDL Program", 
                            0,
                            0,
                            640,
                            480, 
                            SDL_WINDOW_SHOWN);
    // After we create our window, we now can create our renderer
    SDL_Renderer* renderer = SDL_CreateRenderer(window,-1,SDL_RENDERER_ACCELERATED);
    
    // Get the window surface
    SDL_Surface* windowSurface  = SDL_GetWindowSurface(window);
    // Load a test image
    SDL_Surface* myTestImage    = SDL_LoadBMP("./assets/images/test.bmp");
    // Create a texture
    SDL_Texture* myTexture      = SDL_CreateTextureFromSurface(renderer, myTestImage);

    // Free our test image
    // We don't need it anymore since our texture has been stored in video
    // memory.
    SDL_FreeSurface (myTestImage);

    // Create a rectangle for which we will display our image
    SDL_Rect rectangle;
    rectangle.x     = 0;
    rectangle.y     = 0;
    rectangle.w     = 80;
    rectangle.h     = 80;

    bool runGame=true;
    // Main Game Loop
    while(runGame){
        SDL_Event event;
        // Handle input events
        while(SDL_PollEvent(&event)){
            if(event.type == SDL_QUIT){
                runGame= false;
            }
        }
        // Handle updates
        // ...

        // Handle rendering
        // (1) First clear the renderer
        SDL_RenderClear(renderer);
        // (2)
        SDL_RenderCopy(renderer,myTexture,NULL,&rectangle);
        // (3)
        SDL_RenderPresent(renderer);
    }

    // Clean up our texture
    SDL_DestroyTexture(myTexture);
    // Clean up our window
    SDL_DestroyWindow(window);
    // Quit and shutdown SDL
    SDL_Quit();

    return 0;
}


