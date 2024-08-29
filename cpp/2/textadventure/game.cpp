// @file ./textadventure/game.cpp

#include <iostream>

#include "GameState.hpp"

///=============================
/// Main Game Loop Functions 
///=============================
void prompt(){
    std::cout << "1. Advance Story\n";
    std::cout << "2. Go Back in Story\n";
    std::cout << std::endl;
}

/// Handle user input
void input(GameState& gs){
    int value;
    std::cin >> value;
    gs.SetChoice(value);
}

/// update a GameState object
void update(GameState& gs){
   if(1 == gs.GetChoice()){
        gs.SetCurrentLine(gs.GetCurrentLine()+1);
   }
   else if(2 == gs.GetChoice()){
        gs.SetCurrentLine(gs.GetCurrentLine()-1);
   }
}

/// render a GameState Object
void render(GameState& gs){
    gs.PrintCurrentLine();
}

///=============================
/// Program Entry Point 
///=============================
int main(int argc, char* argv[]){

    // Retrieve arguments
    if(argc < 2){
        std::cout << "usage: ./prog story.txt\n";
        return 0;
    }
    
    // Create one instance of our gamestate object on the
    // stack based on the program arguments
    GameState gs(argv[1]);

    // Main Game Loop
    while(true){
        // Print out the prompt
        prompt();
        // Make a choice based on the user input
        input(gs);
        // Update any state in the game
        update(gs);
        // Draw updates to our screen
        render(gs);
    }

}
