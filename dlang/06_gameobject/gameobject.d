// @file: gameobject.d
alias GameEntity = GameObject;
alias GameActor = GameObject;

struct GameObject{

	// Constructor
	this(string name){
		assert(name.length > 0);
		mName = name;	
	}

	// Destructor
	~this(){
	
	}

	private:
	// Any private fields that make up the game object
	string mName;

}

void main(){
	// Stack allocated game object
	GameObject stackGameObject = GameObject("GameObject1");

	// Heap allocated game object
	GameObject* heapGameObject = new GameObject("GameObject2");
}
