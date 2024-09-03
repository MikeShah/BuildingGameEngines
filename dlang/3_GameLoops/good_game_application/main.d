// @file /good_game_application/main.d
// Compile with: dmd *.d -of=prog
// Run with    : ./prog
import std.stdio;
import gameapplication;

void input(){
	writeln("input");
}

void update(){
	writeln("update");
}

void render(){
	writeln("render");
}

// Entry point into program
void main(string[] args){

	try{
		GameApplication app = GameApplication(args);
		app.SetFunctionPointer!"InputFunc"(&input);
		app.SetFunctionPointer!"UpdateFunc"(&update);
		app.SetFunctionPointer!"RenderFunc"(&render);
//	throw new Exception("hi"); // Uncomment me to see an 'error' message
		app.Run();
	}catch(Exception e){
		stderr.writeln("Captured exception message:",e.message);
	}
}
