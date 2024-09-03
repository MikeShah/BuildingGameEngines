// This is a better example of a 'game struct'
// 1. It's testable (We can create multiple instances)
// 2. State can be encapsulated
// 3. It's a more flexible design
module gameapplication;


//////////////////////////////

// Provide a common interface from which we can derive new
// classes from.
interface GameFrameCallBack{
	void frameStarted();
	void frameEnded();
}

// Example of a new 'callback' to add functionality to our game loop
// Note: Must use a 'class' in dlang, as 'structs' cannot use interface
class PrintFrameCallback : GameFrameCallBack{
	import std.stdio;
	this(){}
	~this(){}
	void frameStarted(){
		writeln("New frame starting");
	}
	void frameEnded(){
		writeln("Frame is ending");
	}	
}
//////////////////////////////

struct GameApplication{
	// Custom enum, that is scoped to the 'GameApplication' struct.
	enum State : int { terminated, paused, running};
	State mGameRunning = State.running;
	// An array of callbacks to be called each iteration of the loop
	private GameFrameCallBack[] mGameFrameCallbacks;

	void AddCallBack(GameFrameCallBack callback){
		mGameFrameCallbacks ~= callback;
	}

	// Constructor
	this(string[] args){
	}
	~this(){
	}
	// Use D language 'template' feature to set the
	// function pointer.
	// A 'mixin' is a literal 'string', that will replace text.
	// This can often save us from writing the same 'getter' and 'setter'
	// functions many times.
	void SetFunctionPointer(string T)(void function() func){
		mixin(T) = func;	
	}
	void Run(){
		while(mGameRunning){
			AdvanceFrame();
		}	
	}

	void AdvanceFrame(){
			if(mGameRunning.paused){
				/* Show pause screen or suspend process */
			}
			// Execute all of our callbacks that users have added
			foreach(callback ; mGameFrameCallbacks){
				callback.frameStarted();
			}

			InputFunc();
			UpdateFunc();
			RenderFunc();			

			// Execute all of our callbacks that users have added
			foreach(callback ; mGameFrameCallbacks){
				callback.frameEnded();
			}
	}
	// Member variables fo function pointers
	void function() InputFunc;
	void function() UpdateFunc;
	void function() RenderFunc;
}
