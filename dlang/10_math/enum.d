// @file: enum.d
import std.stdio;
enum STATE {STANDING, WALKING, RUNNING};
// Some game object
struct GameEntity{
	// State stored with an 'enum'
	STATE mState;

	void Execute(){
		switch(mState){
			case mState.STANDING:
				writeln("Doing standing");
				break;
			case mState.WALKING:
				writeln("Doing walking");
				break;
			case mState.RUNNING:
				writeln("Doing running");
				break;
			default:
				assert(0);
		}
	}
}

void main(){

	GameEntity entity;

	entity.mState = STATE.STANDING;
	entity.Execute();
}
