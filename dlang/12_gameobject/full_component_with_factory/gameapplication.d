// @file: full_component_with_factory/gameapplication.d
import std.conv;
import std.stdio;

import gameobject;
import component;

GameObject CreateTextureGameObject(string name){
		GameObject go = GameObject(name);
	
		auto tex1 = new ComponentTexture(go.GetID());
		go.AddComponent!(ComponentType.TEXTURE)(tex1);
		
		return go;
}

GameObject CreateTextureColliderGameObject(string name){
		GameObject go = GameObject(name);
	
		auto tex1 = new ComponentTexture(go.GetID());
		auto col1 = new ComponentCollision(go.GetID());

		go.AddComponent!(ComponentType.TEXTURE)(tex1);
		go.AddComponent!(ComponentType.COLLISION)(col1);
		
		return go;
}

struct GameApplication{

	this(int objects){
		for(size_t i=0; i < objects; i++){
			// Create some different game objects from a factory
			if(i%2==0){
				mGameObjects ~= CreateTextureColliderGameObject("GameObject"~i.to!string);
			}else{
				mGameObjects ~= CreateTextureGameObject("GameObject"~i.to!string);
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
