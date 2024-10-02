// @file: gameobject1.d
import core.atomic;
import std.stdio;
alias GameEntity = GameObject;
alias GameActor = GameObject;

struct GameObject{
	// Constructor
	this(string name){
		assert(name.length > 0);
		mName = name;	
		// atomic increment of number of game objects
		sGameObjectCount.atomicOp!"+="(1);		
		mID = sGameObjectCount; 
	}

	// Destructor
	~this(){	}

	size_t GetID() const { return mID; }

	private:
	// Any private fields that make up the game object
	string mName;
	size_t mID;

	static shared size_t sGameObjectCount = 0;
}

void main(){
	// Stack allocated game object
	GameObject stackGameObject = GameObject("GameObject1");
	// Heap allocated game object
	GameObject* heapGameObject = new GameObject("GameObject2");

	writeln(stackGameObject.GetID());
	writeln(heapGameObject.GetID());
}
