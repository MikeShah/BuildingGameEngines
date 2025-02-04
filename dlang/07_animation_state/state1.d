// @file: state1.d
import std.stdio;

interface IState{
	void OnUpdate();
	void OnEnter();
	void OnExit();
}
class Idle : IState{
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

struct Hero{
	// Store the state of the Hero
	IState mState;
	
	void SetState(IState state){
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
	h.SetState(new Idle);
	h.Update();
	h.SetState(new Idle);
}
