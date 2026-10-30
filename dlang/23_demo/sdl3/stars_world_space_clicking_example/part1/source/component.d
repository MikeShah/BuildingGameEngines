// @file: full_component/component.d
import std.stdio;
import std.math;

import gameapplication;
import objectmanager;
import gameobject;
import vec2;
import geometry;
import matrix;
import transform;

import bindbc.sdl;

/// An enumeration of all of the possible components that can
/// be added to our game objects.
enum ComponentType{TEXTURE,CIRCLE_COLLIDER,TRANSFORM,AI,SCRIPT};

/// Interface for which any component must be derived from 
interface IComponent{
		void Update();
		void Render(SDL_Renderer* renderer);
}

/// Transform Component
class ComponentTransform : IComponent{

		// Store owner ID
		size_t mOwner;

		// Store transform
		Mat3 mMat3;

		// Constructor which always knows about its owner
		this(size_t owner){
				mOwner = owner;
		}

		//
		this(ref scope return ComponentTransform rhs){
			mMat3 = rhs.mMat3;
		}

		// Destructor
		~this(){}

		override void Update(){
				// Temporary to show rotation
				mMat3 = mMat3 * MakeRotate(1.0f.Radians);
		}

		Mat3 GetMat3(){
			return mMat3;
		}

		void SetMat3(Mat3 m){
			mMat3 = m;
		}

		override void Render(SDL_Renderer* renderer){}
}


/// Texture component.
/// In many ways this is 'fundamental' to drawing things like sprites
/// in that this is the component that draws something of interest to the screen.
class ComponentTexture : IComponent{
		// Constructor
		this(size_t owner){
				mOwner = owner;
		}
		// Destructor
		~this(){}

		// Update
		override void Update(){}

		// Render a texture compoment
		// This component also relies on having a 'transform' such that we can
		// draw at a specific location
		override void Render(SDL_Renderer* renderer){
				SDL_FRect rect;

				// Figure out position based on game object
				GameObject go = ObjectManager.GetGameObject(mOwner);	

				// Multiply in the camera
				auto comp = cast(ComponentTransform)go.GetComponent(ComponentType.TRANSFORM);
				auto m = comp.GetMat3();

				// Modify every position by the camera
				m = Camera.GetViewTransform() * m;
//				writeln(" ========= Transform ==========");
//				m.Print();

				// Get and set the translation
				Vec2f position = m.FromMat3GetTranslation;
				position = WorldToScreenCoordinates(position.x , position.y,640,480);
				rect.x = cast(int)position.x;
				rect.y = cast(int)position.y;

				// Get the rotation angle
				float angle = m.FromMat3GetRotation().Degrees;
				// Get the scale
				Vec2f s = m.FromMat3GetScale();
				rect.w = cast(int)s.x;
				rect.h = cast(int)s.y;
//				writeln(" ========= Transform ==========");

				// Perform the rotation
				SDL_RenderTextureRotated(renderer,mTexture,null,&rect,angle, null,SDL_FLIP_NONE);
		}

		// Load a texture
		void LoadTexture(SDL_Renderer* renderer, string filename){
				import std.string;
				SDL_Surface* surf = SDL_LoadBMP(filename.toStringz);
				if(surf==null){
						assert(0, "Failed to find"~filename);
				}
				mTexture = SDL_CreateTextureFromSurface(renderer, surf);
				SDL_DestroySurface(surf);
		}

		private:
		size_t mOwner;
		SDL_Texture* mTexture;
		uint mWidth, mHeight;
}

/// Component Collider circle as an example
class ComponentColliderCircle : IComponent{
		size_t mOwner;
		float mRadius; 
		float x,y;
		bool mColliding=false;	

		this(size_t owner){
				mOwner = owner;
				mRadius = 10.0f;
		}

		void Update(){
		}

		void Render(SDL_Renderer* renderer){
				// Set the render draw color based on the collision
				if(mColliding){
						SDL_SetRenderDrawColor(renderer,0,255,0,SDL_ALPHA_OPAQUE);
				}else{
						SDL_SetRenderDrawColor(renderer,255,0,0,SDL_ALPHA_OPAQUE);
				}

				for(float i=0; i < 360; i+=1){
						int xPos = cast(int)x+ cast(int)( mRadius*cos(i.DegreesToRadians) );
						int yPos = cast(int)y+ cast(int)( mRadius*sin(i.DegreesToRadians) );
						SDL_RenderPoint(renderer,xPos,yPos);	
				}
		}

		void SetPosition(float x, float y){
				this.x = x;
				this.y = y;
		}

		bool IsColliding(ref ComponentColliderCircle c){
				float distance = sqrt( (x-c.x)*(x-c.x) + (y-c.y)*(y-c.y));
				if( (c.mRadius + mRadius) > distance){
						mColliding = true;
				}else{
						mColliding = false;
				}
				c.mColliding = mColliding;
				return mColliding;
		}
}
