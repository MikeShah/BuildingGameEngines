#include "GameApp.hpp"

// C++ Standard Libraries
#include <iostream>

// Constructor
GameApp::GameApp(){
    // Setup the Video subsystem
    if(SDL_Init(SDL_INIT_VIDEO) < 0){
        std::cout << "SDL could not be initialized: " << std::endl;
        std::cout << "SDL Error: " << SDL_GetError()  << std::endl;
    }else{
        std::cout << "SDL video system is ready" << std::endl;
    }
    // Create a window
    mWindow = SDL_CreateWindow("First SDL Program", 
                            0, 0,
                            640 ,480, SDL_WINDOW_SHOWN);
}


// Destructor
GameApp::~GameApp(){
    // Destroy our window
    SDL_DestroyWindow(mWindow);
    // Shut off SDL
    SDL_Quit();

}

void GameApp::Input(void){
    //  Storage for an SDL Event
    SDL_Event event;
    // SDL_PollEvent pops off any events that are queued up.
    // Thi loop will thus run until all events are handled.
    while(SDL_PollEvent(&event)){
        switch(event.type){
            case SDL_QUIT:
                mRunGame = false;
                break;
            case SDL_KEYDOWN:
                if(event.key.state == SDL_PRESSED){
                    std::cout << "Some key pressed\n";
                    std::cout << event.key.keysym.scancode<< '\n';
                }
                break;
        }

    }
}

void GameApp::Update(void){
}

void GameApp::Render(void){

}

