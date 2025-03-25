module sprite;

// Load the SDL2 library
import bindbc.sdl;

/// Store state for sprites and very simple animation
enum STATE{IDLE, WALK};

/// Sprite that holds a texture and position
struct Sprite{

        int mXPos=50;
        int mYPos=50;
		SDL_Rect mRectangle;
		SDL_Texture* mTexture;
        int mFrame;

        STATE mState;

		this(SDL_Renderer* renderer, string filepath){
			// Load the bitmap surface
			SDL_Surface* myTestImage   = SDL_LoadBMP(filepath.ptr);
			// Create a texture from the surface
			mTexture = SDL_CreateTextureFromSurface(renderer,myTestImage);
			// Done with the bitmap surface pixels after we create the texture, we have
			// effectively updated memory to GPU texture.
			SDL_FreeSurface(myTestImage);

			// Rectangle is where we will represent the shape
			mRectangle.x = mXPos;
			mRectangle.y = mYPos;
			mRectangle.w = 64;
			mRectangle.h = 64;
		}

		void Render(SDL_Renderer* renderer){

			SDL_Rect selection;
			selection.x = 64*mFrame;
			selection.y = 0;
			selection.w = 64;
			selection.h = 64;

			mRectangle.x = mXPos;
			mRectangle.y = mYPos;

    	    SDL_RenderCopy(renderer,mTexture,&selection,&mRectangle);

            if(mState == STATE.WALK){
			    mFrame++;
                if(mFrame > 3){
                    mFrame =0;
                }
            }
		}
}

