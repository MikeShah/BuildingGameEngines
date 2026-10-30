import sdl_abstraction;
import component;
import gameobject;
// Third-party libraries
import bindbc.sdl;

/// Have one place where game objects are stored
static struct ObjectManager{

	// Retrieve a specific game object based on the ID
	static GameObject GetGameObject(size_t id){
		// Do an early exit test to see if id matches game object
		if(id< mGameObjects.length){
			if(id==mGameObjects[id].GetID()){
				return mGameObjects[id];
			}
		}

		// Search all other game ids
		for(size_t i=0; i < mGameObjects.length; i++){
			if(id==mGameObjects[i].GetID()){
				return mGameObjects[i];
			}
		}
		assert(0,"No game object found");
	}

	// Add a new game object
	static AddGameObject(ref GameObject go){
		mGameObjects ~= go;
	}

	// Update compoments of all game objects
	static Update(ComponentType T)(){
		foreach(ref objComponent ; mGameObjects){
			auto c = objComponent.GetComponent(T);
			if(c !is null){
				c.Update();
			}
		}
	}

	// Render Components of all game objects
	static Render(ComponentType T)(SDL_Renderer* renderer){
		foreach(ref objComponent ; mGameObjects){
			auto c = objComponent.GetComponent(T);
			if(c !is null){
				c.Render(renderer);
			}
		}
	}

	static GameObject[] mGameObjects;
}
