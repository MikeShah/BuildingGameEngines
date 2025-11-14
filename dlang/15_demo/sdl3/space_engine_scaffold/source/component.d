// @file: full_component/component.d
import std.stdio;

import linear;

import bindbc.sdl;

enum ComponentType{TEXTURE,COLLISION,TRANSFORM,AI,SCRIPT};

interface IComponent{
	void Update();
	void Render(SDL_Renderer* r);
}

class ComponentTexture : IComponent{
	this(size_t owner){
		mOwner = owner;

		mRect = SDL_FRect(40,40,40,40);
		mRect.x = 100;
		mRect.y = 50;
		mRect.w = 50;
		mRect.h = 75;
	}
	~this(){}
	override void Update(){
		// Note: The 'cast' is so I can get the address and verify we
		//       have different components
		writeln("\tUpdating Texture: ",cast(void*)this);
	}

	
	override void Render(SDL_Renderer* r){
		SDL_SetRenderDrawColor(r,255,0,0,SDL_ALPHA_OPAQUE);
		SDL_RenderRect(r,&mRect);
	}

	SDL_FRect mRect;	
	private:
	size_t mOwner;
}

class ComponentCollision : IComponent{
	this(size_t owner){
		mOwner = owner;

		mRect = SDL_FRect(40,40,40,40);
	}
	~this(){}
	override void Update(){
		// Note: The 'cast' is so I can get the address and verify we
		//       have different components
		writeln("\tUpdating Collision: ",cast(void*)this);
	}
	override void Render(SDL_Renderer* r){
		SDL_SetRenderDrawColor(r,0,255,255,SDL_ALPHA_OPAQUE);
		SDL_RenderRect(r,&mRect);
	}

	SDL_FRect mRect;	
	private:
	size_t mOwner;
}

class ComponentTransform : IComponent{
	this(size_t owner){
		mOwner = owner;
	}
	~this(){}
	override void Update(){
		// Note: The 'cast' is so I can get the address and verify we
		//       have different components
		writeln("\tUpdating Transform: ",cast(void*)this);
	}
	override void Render(SDL_Renderer* r){
	}

    // Translate
    // Also updates internal rectangle
    void Translate(float x,float y){
        mLocalMatrix = mLocalMatrix * mLocalMatrix.Translate(x,y);
    }
    // Scale 
    // Also updates internal scale
    void Scale(float x,float y){
        mLocalMatrix = mLocalMatrix * mLocalMatrix.Scale(x,y);
    }
    // Rotate 
    void Rotate(float angle){
        mLocalMatrix = mLocalMatrix * mLocalMatrix.Rotate(angle);
    }

    Vec2f GetPosition(){
        return mLocalMatrix.FromMat3GetTranslation();
    }

    Vec2f GetScale(){
        return mLocalMatrix.FromMat3GetScale();
    }

    float GetAngle(){
        return mLocalMatrix.FromMat3GetRotation();
    }

    mat3 mLocalMatrix;
    mat3 mWorldMatrix;

	private:
	size_t mOwner;
}
