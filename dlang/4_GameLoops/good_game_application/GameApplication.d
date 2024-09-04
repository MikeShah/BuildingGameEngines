// This is a better example of a 'game struct'
// 1. It's testable (We can create multiple instances)
// 2. State can be encapsulated
// 3. It's a more flexible design
module gameapplication;

struct GameApplication{
	// Custom enum, that is scoped to the 'GameApplication' struct.
	enum State : int { terminated, paused, running};
	State mGameRunning = State.running;

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
			if(mGameRunning.paused){
				/* Show pause screen or suspend process */
			}
			InputFunc();
			UpdateFunc();
			RenderFunc();			
		}	
	}
	// Member variables fo function pointers
	void function() InputFunc;
	void function() UpdateFunc;
	void function() RenderFunc;
}
