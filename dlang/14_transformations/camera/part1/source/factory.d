import component;
import gameobject;

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
		}else if(component == ComponentType.CIRCLE_COLLIDER){
			go.AddComponent!(component)(new ComponentColliderCircle(go.GetID()));
		}else if(component == ComponentType.TRANSFORM){
			go.AddComponent!(component)(new ComponentTransform(go.GetID()));
		}else{
			assert(0, "Did not find right component. Perhaps no case?");
		}
	}
	return go;
}
// Example of an alias to make our GameObjectFactory a bit more clean.
alias MakeSprite = GameObjectFactory!(ComponentType.CIRCLE_COLLIDER,ComponentType.TRANSFORM,ComponentType.TEXTURE);
