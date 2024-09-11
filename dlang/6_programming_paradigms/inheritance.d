// @file: inheritance.d
import std.stdio;

// A user-defined type (i.e custom type) that we create.
class GameEntity{
	this(string name){
		mName = name;
	}
	~this(){
	}
	void PrintName(){
		mName.writeln;
	}
private:
	string mName;
}

class AngryGameEntity : GameEntity{
	this(string name){
		super(name);
	}
	// Note: You need the 'override' keyword here.
	override void PrintName(){
		writeln("SCREAMS, I AM ",mName);
	}
}

void main(){
	// Game Entity can be allocated to anything that is a 'type of'
	// or otherwise in the 'inheritance tree'
	GameEntity entity = new AngryGameEntity("Hero Warrior #1");
	entity.PrintName;
}
