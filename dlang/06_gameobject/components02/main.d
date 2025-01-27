// @file: components02/main.d
import core.atomic;
import std.stdio;

enum ComponentType{TEXTURE,COLLISION,AI,SCRIT};

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
//		writeln(mComponents.keys); // Uncomment to see 'keys'
		foreach(component ; mComponents){
			component.Update();
		}
	}

	// Retrieve specific component type
	// NOTE: This could be 'templated' to avoid passing a
	//       parameter into the function.
	IComponent GetComponent(ComponentType type){
		return mComponents[type];
	}

	// Template parameter
	void AddComponent(ComponentType T)(IComponent component){
		mComponents[T] = component;
	}
	
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

void main(){
	// Create a new game object
	GameObject* mario1 = new GameObject("Mario");
	GameObject* mario2 = new GameObject("Mario");
	GameObject* mario3 = new GameObject("Mario");
	GameObject* mario4 = new GameObject("Mario");
	// Add a new component
	auto tex1 = new ComponentTexture();
	auto tex2 = new ComponentTexture();
	auto tex3 = new ComponentTexture();
	auto tex4 = new ComponentTexture();
	
 	mario1.AddComponent!(ComponentType.TEXTURE)(tex1);
 	mario2.AddComponent!(ComponentType.TEXTURE)(tex2);
 	mario3.AddComponent!(ComponentType.TEXTURE)(tex3);
 	mario4.AddComponent!(ComponentType.TEXTURE)(tex4);

	GameObject*[] objects;
	objects~= mario1;
	objects~= mario2;
	objects~= mario3;
	objects~= mario4;

	foreach(ref o ; objects){
		o.Update();
	}

}
