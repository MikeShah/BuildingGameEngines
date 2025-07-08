// @file bad_game.d
// This is an example of a 'bad' game structure.
// 1. It's not testable
// 2. We don't want to put all of our code in the 'main loop'
// 3. There's not encapsulation

import std.stdio;

// This is a module level constructor.
// It allows us to instantiate 'globals' or other subsystems
// in a deterministic order (as opposed to free 'global variables')
shared static this(){
	writeln("Initialization code runs before main()");
}
// Module level destructor, called when program terminates
shared static ~this(){
	writeln("Shutting down system after 'main'");
}

// Entry point into program
void main(string[] args){

	bool gameRunning = true;
	while(gameRunning){
		// Do some input
		// ...
		// Do some updates
		// ...
		// Do some rendering
		// ... 

		// Note: This is just an example showing that we
		//       need some condition to break the main game loop to 'exit' 
		if(gameRunning){
			gameRunning = false;
		}	
	}

	// Clean up resources
	// ...
}
