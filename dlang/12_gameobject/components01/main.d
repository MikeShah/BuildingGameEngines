// @file: components01/main.d
import core.atomic;
import std.stdio;

interface IComponent{
	void Update();
}

class ComponentTexture : IComponent{
	this(){}
	~this(){}
	override void Update(){
	}

	private:
	uint mWidth, mHeight;
}


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

	void Update(){
		foreach(component ; mComponents){
			component.Update();
		}
	}

	IComponent GetComponent(size_t index){
		return mComponents[index];
	}

	void AddComponent(IComponent component){
		mComponents ~= component;
	}
	
	protected:
	// Common components for all game objects
	// Pointers are 'null' by default in DLang.
	// See reference types: https://dlang.org/spec/property.html#init
	IComponent[] 	mComponents;

	private:
	// Any private fields that make up the game object
	string mName;
	size_t mID;

	static shared size_t sGameObjectCount = 0;
}

void main(){
	// Create a new game object
	GameObject* mario = new GameObject("Mario");
	// Add a new component
	mario.AddComponent(new ComponentTexture());
	// Or equivalently
	// auto tex = new ComponentTexture();
	// mario.AddComponent(tex);
}
