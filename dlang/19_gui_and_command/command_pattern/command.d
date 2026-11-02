// @file: command.d
import std.stdio;

interface Command{
	int Execute();
	int Undo();
}

class WalkTo : Command{
	this(int to_x, int to_y){ 
		dest_x = to_x;
		dest_y = to_y;
	}
	override int Execute(){ 
		writeln("heading to: ",dest_x,",",dest_y);
		 /* rest of algorithm...  */ 
		return 0;	
	}
	override int Undo(){ /* */ return 0;	}

	// Position
	int current_x,current_y;
	// Destination
	int dest_x, dest_y;
	// previous position
	int prev_x, prev_y;
}

void main(){
	Command[] commands;
	commands ~= new WalkTo(5,7);
	commands ~= new WalkTo(4,2);

	while(commands.length >0){
		commands[0].Execute();
		commands = commands[1..$]; // pop() command
	}

}
