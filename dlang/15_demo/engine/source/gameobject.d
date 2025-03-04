// @file: full_component/gameobject.d
import core.atomic;
import std.stdio;
import std.conv;

import component;
import script;

class GameObject{

		//  Map of all game objects
		static GameObject[string] sGameObjects;
		static string[size_t] sGameObjectsNameToID;

		// Retrieve a Game Object by name
		static GameObject GetGameObject(string name){
				if(name in sGameObjects){
						return sGameObjects[name];
				}
				assert(0, "Game object '"~name~"' does not exist");
		}   

		// Retrieve a Game Object by ID 
		static GameObject GetGameObject(size_t id){
				if(id in sGameObjectsNameToID){
						return sGameObjects[sGameObjectsNameToID[id]];
				}
				assert(0, "Game Object "~id.to!string~" does not exist");
		}   


		// Constructor
		this(string name){
				assert(name.length > 0);
				mName = name;	
				// atomic increment of number of game objects
				sGameObjectCount.atomicOp!"+="(1);		
				mID = sGameObjectCount; 

				// Store game object
				sGameObjects[name] = this;
				// Store ID to GameObject
				sGameObjectsNameToID[mID] = name;
		}

		// Destructor
		~this(){	}

		string GetName() const { return mName; }
		size_t GetID() const { return mID; }

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

		// Template parameter
		void AddComponent(ComponentType T)(IComponent component){
				mComponents[T] = component;
		}

		/// Scripts
		IScript[] mScripts;

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
