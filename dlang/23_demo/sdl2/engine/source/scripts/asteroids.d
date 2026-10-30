module asteroids;

import std.stdio;
import linear;
import gameobject;
import component;
import scripts;

class AsteroidScript : IScript{

		// Local state for every instance of Asteroid script
		bool mXDirection=true;
		bool mYDirection=true;

		this(size_t owner){
				mOwner = owner;
		}

		override void Update(){
				writeln("Running Asteroid Script");
				// Retrieve the game object
				GameObject go = GameObject.GetGameObject(mOwner);
				// Retrieve the world
				GameObject world = GameObject.GetGameObject("world");
				auto bounds = cast(ComponentCollision)world.GetComponent(ComponentType.COLLISION);

				// Get object tranform
				auto transform = cast(ComponentTransform)go.GetComponent(ComponentType.TRANSFORM);

				// Move objects
				if(mXDirection){
					transform.Translate(1,0);
				}else{
					transform.Translate(-1,0);
				}
				if(mYDirection){
					transform.Translate(0,1);
				}else{
					transform.Translate(0,-1);
				}

				// Check against world bounds 
				Vec2f position = transform.GetPosition();
				int bounds_width = bounds.mRect.w;
				int bounds_height= bounds.mRect.h;
			
				if(position.x > bounds_width){
					mXDirection = false;
				}
				if(position.x < 0){
					mXDirection = true;
				}
				if(position.y > bounds_height){
					mYDirection = false;
				}
				if(position.y < 0){
					mYDirection = true;
				}



		}

		private:
		size_t mOwner;
}
