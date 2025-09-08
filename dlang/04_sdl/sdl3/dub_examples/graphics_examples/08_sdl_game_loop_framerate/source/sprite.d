
// Third-party libraries
import bindbc.sdl;

struct Sprite{

	SDL_Texture* mTexture;
	SDL_FRect     mRectangle;

	this(SDL_Renderer* renderer, string bitmapFilePath){
		import std.string; // for toZString
		// Create a texture
		SDL_Surface* mSurface = SDL_LoadBMP(bitmapFilePath.toStringz);
		mTexture = SDL_CreateTextureFromSurface(renderer,mSurface);
		SDL_DestroySurface(mSurface);
		// Position the rectangle 
		mRectangle.x = 50;
		mRectangle.y = 50;
		mRectangle.w = 100;
		mRectangle.h = 100;
	}

	// Destroy anything 'heap' allocated.
	// Remember, SDL is a C library, thus heap allocated resources need
	// to be destroyed
	~this(){
		SDL_DestroyTexture(mTexture);
	}

	void Input(){}
	void Update(){
				static int x =0;
				static int y =0;
				static int xDirection=1;
				static int yDirection=1;
				
				if(xDirection==1){ ++x; }
				else if(xDirection==-1){ --x; }

				if(yDirection==1){ ++y; }
				else if(yDirection==-1){ --y; }
				
				if(mRectangle.x > 540){xDirection=-1;}
				if(mRectangle.x < 0){xDirection=1;}
				if(mRectangle.y > 380){yDirection=-1;}
				if(mRectangle.y < 0){yDirection=1;}
			
				mRectangle.x = 50+ x;
				mRectangle.y = 50+ y;
				mRectangle.w = 100;
				mRectangle.h = 100;
	}

	void Render(SDL_Renderer* renderer){
				// Copy a texture (or portion of a texture) to another
				// portion of video memory (i.e. a 2D grid of texels 
				// which span the width and height of the window)
				SDL_RenderTexture(renderer,mTexture,null,&mRectangle);
	}
}
