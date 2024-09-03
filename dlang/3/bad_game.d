// @file bad_game.d
// This is an example of a 'bad' game structure.
// 1. It's not testable
// 2. We don't want to put all of our code in the 'main loop'
// 3. There's not encapsulation

import std.stdio;

shared static this(){
	writeln("Initialization code runs before main()");
}

void main(string[] args){

	while(true){
		/*
			Game code goes here


		*/
	}
}
