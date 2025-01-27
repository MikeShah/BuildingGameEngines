// @file: full_component/gameapplication.d
import std.conv;
import std.stdio;

import gameobject;
import component;

struct GameApplication{

	this(int objects){
		for(size_t i=0; i < objects; i++){
			// Create a new game object
			mGameObjects ~= GameObject("GameObject"~i.to!string);
			auto tex1 = new ComponentTexture(mGameObjects[i].GetID());
			// Add a texture component
 			mGameObjects[i].AddComponent!(ComponentType.TEXTURE)(tex1);

			// Arbitrarily add collision components to some objects
			if(i%2==0){
				auto col1 = new ComponentCollision(mGameObjects[i].GetID());
 				mGameObjects[i].AddComponent!(ComponentType.COLLISION)(col1);
			}
		}
	}

	void Input() {}
	void Render() {}

	void Update() {
		// Update components individually
		// Update texture components
		foreach(ref objComponent; mGameObjects){
				writeln(objComponent.GetName());
				auto tex = objComponent.GetComponent(ComponentType.TEXTURE);
				if(tex !is null){
					tex.Update();
				}
		}

		// Update Collision Components
		foreach(ref objComponent; mGameObjects){
				writeln(objComponent.GetName());
				auto col = objComponent.GetComponent(ComponentType.COLLISION);
				if(col !is null){
					col.Update();
				}
		}
	}
	void AdvanceFrame(){
			Input();
			Update();
			Render();	
	}

	void Run(){
			while(mGamerunning){
				AdvanceFrame();
			}
	}
	
	GameObject[] mGameObjects;
	bool mGamerunning=true;
}
