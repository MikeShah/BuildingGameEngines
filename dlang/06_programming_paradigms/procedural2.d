// @file: procedural2.d
import std.stdio;

enum SHAPE{Square, Circle, Pentagon, END}
enum STATE{Running, Paused, Off, Error}

void func(SHAPE s){
	if(SHAPE.Square == s){
		writeln("Square");
	}else{
		writeln("Not a square");
	}	
}

void func2(STATE s){
	switch(s){
		case STATE.Running:
			writeln("Running");
			break;
		case STATE.Paused:
		case STATE.Off:
		case STATE.Error:
		default:
			break;
	}
}

// Special type of data type 'union' that holds
// one data member at a time.
union Event{
	int type;
	struct mouse_event{
		int type;
		bool left, middle, right;
	}
	struct key_event{
		int type;
		char[255] states;
	}
}

void main(){
}
