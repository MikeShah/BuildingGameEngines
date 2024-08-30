// @file ./textadventure/game.d

// compile with: dmd -g main.d GameState.d -of=prog
// compile with: ldc2 -g main.d GameState.d -of=prog

import std.stdio;
import gamestate;

///=============================
/// Main Game Loop Functions 
///=============================
void prompt(){
    writeln("1. Advance Story");
    writeln("2. Go Back in Story");
}

/// Handle user input
void input(ref GameState gs){
    int value;
		// Note: This is somewhat brittle in that we account for the endline character
		//       You can consider 'readln' then convert 'string' input to int using
		//       to!string and using 'import std.conv;'
    readf!"%d\n"(value);
    gs.SetChoice(value);
}

/// update a GameState object
void update(ref GameState gs){
   if(1 == gs.GetChoice()){
        gs.SetCurrentLine(gs.GetCurrentLine()+1);
   }
   else if(2 == gs.GetChoice()){
        gs.SetCurrentLine(gs.GetCurrentLine()-1);
   }
}

/// render a GameState Object
void render(ref GameState gs){
    gs.PrintCurrentLine();
}

///=============================
/// Program Entry Point 
///=============================
void main(string[] args){

    // Retrieve arguments
    if(args.length < 2){
        writeln("usage: ./prog story.txt\n");
        return;
    }
    // Create one instance of our gamestate object on the
    // stack based on the program arguments
    GameState gs = GameState(args[1]);

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
