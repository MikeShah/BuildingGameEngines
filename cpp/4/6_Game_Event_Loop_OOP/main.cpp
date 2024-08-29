// @ File ./6_Game_Event_Loop_OOP/main.cpp

// On linux compile with:
// g++ -std=c++17 *.cpp -o prog -lSDL2

#include "GameApp.hpp"

// Program entry point
int main(int argc, char* argv[]){
    // Create an instance of a 'GameApp' named game.
    GameApp game;
    // Main Loop
    while(game.mRunGame){
        // Handle Input
        game.Input();
        // Handle Update
        game.Update();
        // Render
        game.Render();
    }

    return 0;
}


