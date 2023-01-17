#ifndef GAMEAPP_HPP
#define GAMEAPP_HPP

// Third-party library
#include <SDL2/SDL.h>

/// Game Application
struct GameApp{

    // Constructor
    GameApp();

    // Destructor
    ~GameApp();

    // Input
    void Input(void);

    // Update
    void Update(void);

    // Render
    void Render(void);

    ////////// Member Variables /////////
    SDL_Window* mWindow;
    bool mRunGame = true;
};


#endif
