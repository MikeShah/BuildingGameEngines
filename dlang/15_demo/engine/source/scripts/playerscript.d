// @file: full_component/script.d
import std.stdio;

import linear;
import gameobject;
import component;
import scripts;

import bindbc.sdl;


class PlayerScript : IScript{

		Vec2f mAcceleration;

		this(size_t owner){
				mOwner = owner;
		}

		// TODO: Set boundaries
		override void Update(){
				writeln("Running PlayerScript");
				// Retrieve the game object
				GameObject go = GameObject.GetGameObject(mOwner);

				auto transform = cast(ComponentTransform)go.GetComponent(ComponentType.TRANSFORM);
				writeln("Player local transform:",transform.mLocalMatrix);
				writeln("Player world transform:",transform.mWorldMatrix);

				// Get Keyboard input
				const ubyte* keyboard = SDL_GetKeyboardState(null);

				// Check for movement
				if(keyboard[SDL_SCANCODE_LEFT] ){ 
						mAcceleration = mAcceleration + Vec2f(-1,0);
				}
				if(keyboard[SDL_SCANCODE_RIGHT]){
						mAcceleration = mAcceleration + Vec2f(1,0);
				}
				if(keyboard[SDL_SCANCODE_UP] ){
						mAcceleration = mAcceleration + Vec2f(0,-1);
				}
				if(keyboard[SDL_SCANCODE_DOWN]){
						mAcceleration = mAcceleration + Vec2f(0,1);
				}
				
				// Set cap on acceleration
				if(mAcceleration.x > 2){ mAcceleration.x =2; }
				if(mAcceleration.x < -2){ mAcceleration.x =-2; }
				if(mAcceleration.y > 2){ mAcceleration.y =2; }
				if(mAcceleration.y < -2){ mAcceleration.y =-2; }

				// Decceleration
				if(mAcceleration.x > 0){
					mAcceleration.x -= 0.01f;
				}
				if(mAcceleration.x < 0){
					mAcceleration.x += 0.01f;
				}
				if(mAcceleration.y > 0){
					mAcceleration.y -= 0.01f;
				}
				if(mAcceleration.y < 0){
					mAcceleration.y += 0.01f;
				}

				// Perform acceleration
				transform.Translate(mAcceleration.x,mAcceleration.y);

		}


		private:
		size_t mOwner;
}
