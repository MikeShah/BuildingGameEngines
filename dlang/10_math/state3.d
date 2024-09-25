// @file: state3.d
import std.stdio;

interface IState{
	void OnUpdate();
	void OnEnter();
	void OnExit();
}
class Idle : IState{

	Hero* mHeroReference;

	this(Hero* heroRef){
		mHeroReference = mHeroReference;
	}

	void OnEnter(){
			"allocate idle resources".writeln;
	}
	void OnUpdate(){
			"idle.OnUpdate called".writeln;
	}
	void OnExit(){
			"Exit and cleanup".writeln;
	}
}

// Returns true/false if this is a legal
// transition
bool IsLegal(IState currentState, IState newState){
	// Perform some lookup to see if
	// transition is legal.
	// i.e. need a graph structure

	return true;
}

struct Hero{
	// Store the state of the Hero
	IState mState;
	
	void SetState(IState state){
		if(!IsLegal(mState,state)){
			return;
		}

		if(mState !is null){
			mState.OnExit();
		}		
		mState = state;	
		mState.OnEnter();
	}
	void Update(){
		mState.OnUpdate();
	}
}

void main(){
	Hero h;
	h.SetState(new Idle(&h));
	h.Update();
	h.SetState(new Idle(&h));
}
