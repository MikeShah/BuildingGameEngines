// @file behaviors/strategy4.d
import std.stdio;
import core.thread;
// Some component types
enum ComponentTypes{COLLISION, IMAGE};

// Component interface
interface IComponent{
	void Update();
}

// New scriptable component
class ScriptComponent : IComponent{
	this(){mID = ++sID;}
	void Update(){
		writefln(" ScriptComponent #%d is updating",mID);	
	}
	int mID;
	static int sID;
}

class AlienScript : ScriptComponent{
	override void Update(){
		writefln(" AlientScript #%d is updating",mID);	
	}
}
class PlayerScript: ScriptComponent{
	override void Update(){
		writefln(" PlayerScript #%d is updating",mID);	
	}
}

struct GameObject{
	// Attributes and Behaviors
	void Update(){
		// Update components
		foreach(c ; mComponents){
			c.Update();
		}
		// Update scripts
		foreach(s ; mScripts){
			s.Update();
		}
	}
	// Different component types
	IComponent[ComponentTypes] mComponents;
	// Allow for multiple scripts to be attached
	ScriptComponent[] mScripts;
}


void main(){

	GameObject player;
	player.mScripts ~= new PlayerScript();	

	GameObject alien;
	alien.mScripts ~= new AlienScript();	

	while(true){
		Thread.sleep(500.msecs);
		player.Update();
		alien.Update();

	}
}
