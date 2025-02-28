module factory;

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

// Meta-programming to generate factories for creating game objects
// See: https://dlang.org/articles/variadic-function-templates.html
// CAUTION: Each new ordering of components will instantiate a new type.
// 					I'd thus recommend 'sorting' the variadic arguments. That takes
//          a little bit more work, and I'll leave as an exercise until someone asks..
GameObject GameObjectFactory(T...)(string name){
	// Create our game object
	GameObject go = GameObject(name);
	// Static foreach loop will be 'unrolled' with
	// each 'if' condition for what is true.
	// This could also handle the case where we repeat component types as well if our
	// game object supports multiple components of the same type.
	static foreach(component ; T){
		static if(component == ComponentType.TEXTURE){
			go.AddComponent!(component)(new ComponentTexture(go.GetID()));
		}else if(component == ComponentType.COLLISION){
			go.AddComponent!(component)(new ComponentCollision(go.GetID()));
		}else{
			assert(0, "Did not find right component");
		}
	}
	return go;
}
// Example of an alias to make our GameObjectFactory a bit more clean.
alias MakeCollisionTexture = GameObjectFactory!(ComponentType.COLLISION,ComponentType.TEXTURE);
