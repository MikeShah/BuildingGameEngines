// @file: state.d
import std.stdio;

interface IState{
	void OnUpdate();
}
class Idle : IState{
	void OnUpdate(){"idle".writeln;}
}
class Running : IState{
	void OnUpdate(){"running".writeln;}
}

struct Hero{
	// Store the state of the Hero
	IState mState;

	void SetState(IState state){
		mState = state;	
	}
	void Update(){
		mState.OnUpdate();
	}
}

void main(){
	Hero h;

	h.SetState(new Running);
	h.Update();

	h.SetState(new Idle);
	h.Update();
}
