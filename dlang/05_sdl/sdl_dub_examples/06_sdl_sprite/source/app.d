/// @file: sdl_dub_examples/06_sdl_sprite/app.d
import std.stdio;
import sdl_abstraction;
import bindbc.sdl;

struct Sprite{

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
	}

	// Destroy anything 'heap' allocated.
	// Remember, SDL is a C library, thus heap allocated resources need
	// to be destroyed
	~this(){
		SDL_DestroyTexture(mTexture);
	}

	void Input(){}
	void Update(){}

	void Render(SDL_Renderer* renderer){
				// Copy a texture (or portion of a texture) to another
				// portion of video memory (i.e. a 2D grid of texels 
				// which span the width and height of the window)
				SDL_RenderCopy(renderer,mTexture,null,&mRectangle);
	}
}

void main()
{
		SDL_Window* window = SDL_CreateWindow("Dlang SDL Window",
						0,0, 640,480, SDL_WINDOW_SHOWN);

		// Create a hardware accelerated mRenderer
		SDL_Renderer* renderer = SDL_CreateRenderer(window,-1,SDL_RENDERER_ACCELERATED);

		Sprite mySprite = Sprite(renderer,"./assets/images/test.bmp");

		bool gameIsRunning=true;
		while(gameIsRunning){
				// Store an SDL Event
				SDL_Event event;
				while(SDL_PollEvent(&event)){
						if(event.type == SDL_QUIT){
								writeln("Exit event triggered");
								gameIsRunning= false;
						}
						if(event.type == SDL_KEYDOWN){
								writeln("Pressed a key ");
						}
				}
			
				// Update our sprite
				mySprite.Update();

				// Set the render draw color 
				SDL_SetRenderDrawColor(renderer,100,190,255,SDL_ALPHA_OPAQUE);
				// Clear the renderer each time we render
				SDL_RenderClear(renderer);

				mySprite.Render(renderer);

				// Final step is to present what we have copied into
				// video memory
				SDL_RenderPresent(renderer);
		}
		// Destroy our renderer
		SDL_DestroyRenderer(renderer);
		// Destroy our window
		SDL_DestroyWindow(window);
} // end main()
