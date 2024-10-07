// Third-party libraries
import bindbc.sdl;

struct Vec3{
    float x,y,w;
}

struct Mat3{
    float[3][3] e; // 'e' is short for 'elements' in the matrix

    void MakeIdentity(){
        e[0][0] = 1.0f;
        e[1][1] = 1.0f;
        e[2][2] = 1.0f;
    }

    typeof(this) MakeTranslation(float x, float y){

        e[0][0] = 1.0f;     e[0][1] = 1.0f;     e[0][2] = x;
        e[1][0] = 1.0f;     e[1][1] = 1.0f;     e[1][2] = y;
        e[2][0] = 1.0f;     e[2][1] = 1.0f;     e[2][2] = 1.0f;

        return e;
    }
}

Vec3 opBinary(Vec3 v, Transform){
    Vec3 result;

    return result;
}

struct Transform{
    Mat3 m;

    typeof(this) Identity(){
        m.MakeIdentity();
        return this;
    }

    typeof(this) Translate(float x, float y){
        m = m & Mat3.MakeTranslation(x,y); 

        return this;
    }
    typeof(this) Scale(float x, float y){
        return this;
    }
    typeof(this) Rotate(float angle){

        return this;
    }
}

struct GameObject{

        Transform mTransform;
		SDL_Texture* mTexture;
		SDL_Rect     mRectangle;

		this(SDL_Renderer* renderer, string bitmapFilePath){
				import std.string; // for toZString
													 // Create a texture
				SDL_Surface* mSurface = SDL_LoadBMP(bitmapFilePath.toStringz);
				mTexture = SDL_CreateTextureFromSurface(renderer,mSurface);
				SDL_FreeSurface(mSurface);
				// Position the rectangle 
				mRectangle.x = 50;
				mRectangle.y = 50;
				mRectangle.w = 100;
				mRectangle.h = 100;


                mTransform.Identity();
		}

		// Destroy anything 'heap' allocated.
		// Remember, SDL is a C library, thus heap allocated resources need
		// to be destroyed
		~this(){
				SDL_DestroyTexture(mTexture);
		}

		void Input(){}
		void Update(){

				mRectangle.x = 50;
				mRectangle.y = 50;
				mRectangle.w = 100;
				mRectangle.h = 100;
		}

		void Render(SDL_Renderer* renderer){
				// Selects a portion of the sprite sheet that we want
				// to draw from our renderer. We can think of this as 'copying'
				// data -- but really we are just selecting the 'texture coordinates'
				// within our GPU memory of what to draw.
				SDL_Rect selection;
				selection.x = 64;
				selection.y = 0;
				selection.w = 64;
				selection.h = 64;
				// Copy a texture (or portion of a texture) to another
				// portion of video memory (i.e. a 2D grid of texels 
				// which span the width and height of the window)
				SDL_RenderCopy(renderer,mTexture,&selection,&mRectangle);
		}
}
