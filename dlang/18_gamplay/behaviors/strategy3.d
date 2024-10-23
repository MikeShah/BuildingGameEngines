// @file behaviors/strategy3.d
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

	GameObject go;
	go.mScripts ~= new ScriptComponent();	
	go.mScripts ~= new ScriptComponent();	
	go.mScripts ~= new ScriptComponent();	

	while(true){
		Thread.sleep(500.msecs);
		go.Update();

	}

}
