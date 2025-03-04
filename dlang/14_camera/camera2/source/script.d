// @file: full_component/script.d
import std.stdio;

import linear;
import gameobject;
import component;

import bindbc.sdl;

interface IScript{
	void Update();
}

class PlayerScript : IScript{

	this(size_t owner){
		mOwner = owner;
	}

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
            transform.Translate(-1,0);
        }
        if(keyboard[SDL_SCANCODE_RIGHT]){
            transform.Translate(1,0);
        }
        if(keyboard[SDL_SCANCODE_UP] ){
            transform.Translate(0,-1);
        }
        if(keyboard[SDL_SCANCODE_DOWN]){
            transform.Translate(0,1);
        }

        // Update the Texture to be in sync with the transform
        auto texture = cast(ComponentTexture)go.GetComponent(ComponentType.TEXTURE);
        Vec2f pos = transform.GetPosition() ;
        texture.mRect.x = cast(int)pos.x;
        texture.mRect.y = cast(int)pos.y;
    }


	private:
	size_t mOwner;
}
