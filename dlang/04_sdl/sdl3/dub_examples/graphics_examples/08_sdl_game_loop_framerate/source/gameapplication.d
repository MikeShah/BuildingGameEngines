// 07_sdl_game_loop/gameapplication.d
module gameapplication;
// Import D standard libraries
import std.stdio;
import std.string;
import std.conv;

// Third-party libraries
import bindbc.sdl;

// Import our SDL Abstraction
import sdl_abstraction;

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

struct GameApplication{
		SDL_Window* mWindow = null;
		SDL_Renderer* mRenderer = null;
		bool mGameIsRunning = true;

		// Game Data
		Sprite mySprite;

		// Constructor
		this(string title){
				// Create an SDL window
				mWindow = SDL_CreateWindow(title.toStringz, 640, 480, SDL_WINDOW_ALWAYS_ON_TOP);

				// Create a hardware accelerated mRenderer
				mRenderer = SDL_CreateRenderer(mWindow,null);
				// Load the bitmap surface
				mySprite = Sprite(mRenderer,"./assets/images/test.bmp");
		}

		// Destructor
		~this(){
				// Destroy our renderer
				SDL_DestroyRenderer(mRenderer);
				// Destroy our window
				SDL_DestroyWindow(mWindow);
		}

		// Handle input
		void Input(){
				SDL_Event event;
				// Start our event loop
				while(SDL_PollEvent(&event)){
						// Handle each specific event
						if(event.type == SDL_EVENT_QUIT){
								mGameIsRunning= false;
						}
				}
			mySprite.Input();
		}

		void Update(){
			mySprite.Update();
		}

		void Render(){
				// Set the render draw color 
				SDL_SetRenderDrawColor(mRenderer,100,190,255,SDL_ALPHA_OPAQUE);
				// Clear the renderer each time we render
				SDL_RenderClear(mRenderer);

				mySprite.Render(mRenderer);

				// Final step is to present what we have copied into
				// video memory
				SDL_RenderPresent(mRenderer);
		}

		// Advance world one frame at a time
		void AdvanceFrame(ulong elapsedTime){
				Input();
				Update();
				Render();
		}

		void RunLoop(){
				// Main application loop
				auto previous = SDL_GetTicks();
				auto accumulatedTime = 0;
				auto framesCompleted=0;
				while(mGameIsRunning){
						auto current = SDL_GetTicks();	// Current frame time
						auto elapsed = SDL_GetTicks() - previous; // elapsed time since last frame
						AdvanceFrame(elapsed);

						previous = current;		// Update the 'previous time'
						accumulatedTime += elapsed;
				
						// Every '1' second of accumulated time, report the number of
						// frames that have been completed
						if(accumulatedTime > 1000){
							string framerate = "Framerate is: "~framesCompleted.to!string;	
							SDL_SetWindowTitle(mWindow,framerate.toStringz);
							accumulatedTime = 0;
							framesCompleted=0;
						}
						framesCompleted++;
				}
		}
}
