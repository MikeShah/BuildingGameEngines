// @file: encapsulation.d
import std.stdio;

// A user-defined type (i.e custom type) that we create.
class GameEntity{
	// Constructor
	// Actions performed while creating object
	this(string name){
		mName = name;
	}
	// Destructor
	~this(){
	}

	// A public member function that acts on a specific instance
	// of an object.
	void PrintName(){
		mName.writeln;
	}

// Everything 'below' here is 'hidden' outside of this
// module.
private:

	// Fields or 'member variables'
	// Each instance of 'GameEntity' has their own data
	string mName;
}

void main(){
	// Note: 'class' types generally need to be heap allocated.
	GameEntity entity = new GameEntity("Hero Warrior #1");
	entity.PrintName;
}
