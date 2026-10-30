// Standard Libraries
import core.atomic;
import std.stdio;
import std.algorithm;
import std.conv;
import std.array;
// Project Libraries

// Third-party libraries
import bindbc.sdl;

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

	// Copy Constructor
//	this(ref return scope GameObject rhs){
//		writeln("Copy called:",rhs.mID);
//		mName = rhs.mName;
//		mID   = mID;
//		this.mComponents=  mComponents.dup;
//	}

	// Destructor
	~this(){	}


	void Update(){
	}

	// Retrieve specific component type
	// NOTE: This could be 'templated' to avoid passing a
	//       parameter into the function.
	IComponent GetComponent(ComponentType type){
		if(type in mComponents){
			return mComponents[type];
		}else{
			return null;
		}
	}

	void SetComponent(ComponentType T)(IComponent  t){
		mComponents[T] = t;
	}

	// Template parameter
	void AddComponent(ComponentType T)(IComponent component){
		mComponents[T] = component;
	}

	// Retrieve name of game object	
	string GetName() const { return mName; }

	// Retrieve unique ID of game object
	size_t GetID() const { return mID; }

	protected:
	// Common components for all game objects
	// Pointers are 'null' by default in DLang.
	// See reference types: https://dlang.org/spec/property.html#init
	IComponent[ComponentType] 	mComponents;

	private:
	// Any private fields that make up the game object
	string mName;
	size_t mID;

	static shared size_t sGameObjectCount = 0;
}
