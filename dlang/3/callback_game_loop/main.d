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
	
		// Create some custom callbacks
		// Note: classes need to be allocated on the heap
		PrintFrameCallback callback = new PrintFrameCallback;
		app.AddCallBack(callback);

//	throw new Exception("hi"); // Uncomment me to see an 'error' message
		app.Run();
	}catch(Exception e){
		stderr.writeln("Captured exception message:",e.message);
	}
}

// We also have the ability to 'unittest' our game application.
unittest{
		// Run with 'dmd ./src/*.d -unittest -of=test && ./test
		string[] args;
		GameApplication app = GameApplication(args);
		app.SetFunctionPointer!"InputFunc"(&input);
		app.SetFunctionPointer!"UpdateFunc"(&update);
		app.SetFunctionPointer!"RenderFunc"(&render);
	  // Do some interseting test here...
		app.AdvanceFrame();
		// assert some property of the game state here
}

// Do another unit test here ....
unittest{
		string[] args;
		GameApplication app = GameApplication(args);
		app.SetFunctionPointer!"InputFunc"(&input);
		app.SetFunctionPointer!"UpdateFunc"(&update);
		app.SetFunctionPointer!"RenderFunc"(&render);
	  // Do some interseting test here...
		for(int i=0; i < 50; i++){
			app.AdvanceFrame();
		}
}

