/// @file: sdl_dub_examples/06_sdl_sprite/app.d
import std.stdio;
import sdl_abstraction;
import bindbc.sdl;

struct Sprite{

	SDL_Texture* mTexture;
	SDL_FRect     mRectangle;
	SDL_FRect     mSourceRectangle;


	this(SDL_Renderer* renderer, string bitmapFilePath, float x, float y, float w, float h){
		import std.string; // for toZString
		// Create a texture
		SDL_Surface* mSurface = SDL_LoadBMP(bitmapFilePath.toStringz);
		mTexture = SDL_CreateTextureFromSurface(renderer,mSurface);
		SDL_DestroySurface(mSurface);
		// Position the rectangle 
		mRectangle.x = x;
		mRectangle.y = y;
		mRectangle.w = w;
		mRectangle.h = h;
    // Set source rectangle to be 'empty' or 'null'
    mSourceRectangle.x =0;
    mSourceRectangle.y =0;
    mSourceRectangle.w =0;
    mSourceRectangle.h =0;
	}

	// Destroy anything 'heap' allocated.
	// Remember, SDL is a C library, thus heap allocated resources need
	// to be destroyed
	~this(){
		SDL_DestroyTexture(mTexture);
	}

	void Input(){}
	void Update(){}

  void MoveSprite(float x, float y){
    mRectangle.x = x;
    mRectangle.y = y;
  }

  void SetSourceRectangle(float x, float y, float w, float h){
    mSourceRectangle.x =x;
    mSourceRectangle.y =y;
    mSourceRectangle.w =w;
    mSourceRectangle.h =h;
  }

	void Render(SDL_Renderer* renderer, SDL_BlendMode mode){
        // Set the texture blend mode
        SDL_SetTextureBlendMode(mTexture,mode);
				// Copy a texture (or portion of a texture) to another
				// portion of video memory (i.e. a 2D grid of texels 
				// which span the width and height of the window)
        if(mSourceRectangle.w ==0 && mSourceRectangle.h ==0){
				  SDL_RenderTexture(renderer,mTexture,null,&mRectangle);
        }else{
				  SDL_RenderTexture(renderer,mTexture,&mSourceRectangle,&mRectangle);
        }
	}
}

void main()
{
		SDL_Window* window = SDL_CreateWindow("Dlang SDL Mike Fake Lighting", 640,480, SDL_WINDOW_ALWAYS_ON_TOP);

		// Create a hardware accelerated mRenderer
		SDL_Renderer* renderer = SDL_CreateRenderer(window,null);

		Sprite mySprite = Sprite(renderer,"./assets/images/background.bmp",0,0,640,480);
		Sprite fakeLight= Sprite(renderer,"./assets/images/light.bmp",0,0,128,128);

    // Store mouse positions
    float mouseX,mouseY;

		bool gameIsRunning=true;
		while(gameIsRunning){
				// Store an SDL Event
				SDL_Event event;
				while(SDL_PollEvent(&event)){
						if(event.type == SDL_EVENT_QUIT){
								writeln("Exit event triggered");
								gameIsRunning= false;
						}
						if(event.type == SDL_EVENT_KEY_DOWN){
								writeln("Pressed a key ");
						}
				}
        SDL_GetMouseState(&mouseX,&mouseY);
			
				// Update our sprite
				mySprite.Update();
				fakeLight.Update();
        fakeLight.SetSourceRectangle(0,0,64,64);
        fakeLight.MoveSprite(mouseX-64,mouseY-64); // The '-64' is to center light around mouse

				// Set the render draw color 
				SDL_SetRenderDrawColor(renderer,100,190,255,SDL_ALPHA_OPAQUE);
				// Clear the renderer each time we render
				SDL_RenderClear(renderer);

				mySprite.Render(renderer, SDL_BLENDMODE_NONE);
				fakeLight.Render(renderer, SDL_BLENDMODE_ADD);

				// Final step is to present what we have copied into
				// video memory
				SDL_RenderPresent(renderer);
		}
		// Destroy our renderer
		SDL_DestroyRenderer(renderer);
		// Destroy our window
		SDL_DestroyWindow(window);
} // end main()
