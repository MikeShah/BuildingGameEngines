// @file: gameobject.d
import core.atomic;
import std.stdio;
import std.conv;

import component;

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

	string GetName() const { return mName; }
	size_t GetID() const { return mID; }

	void Update(){
		foreach(c ; mComponents){
			c.Update();
		}
	}

	// Retrieve specific component type
	// NOTE: This could be 'templated' to avoid passing a
	//       parameter into the function.
	T GetComponent(T)(string componentname){
		if(componentname in mComponents){
			return cast(T)mComponents[componentname];
		}else{
			return null;
		}
	}

	// Template parameter
	void AddComponent(string componentname){
		// Create the component
		IComponent c = ComponentFactory(componentname);
		// Assign owner
		c.mOwner = &this;
		// Add to game objects map of components
		mComponents[componentname] = c; 
	}
	
	protected:
	// Common components for all game objects
	// Pointers are 'null' by default in DLang.
	// See reference types: https://dlang.org/spec/property.html#init
	IComponent[string] mComponents;

	private:
	// Any private fields that make up the game object
	string mName;
	size_t mID;

	static shared size_t sGameObjectCount = 0;
}
