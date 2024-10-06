module gameapplication;
// Import D standard libraries
import std.stdio;
import std.string;

// Third-party libraries
import bindbc.sdl;

// Import our SDL Abstraction
import sdl_abstraction;
import sprite;

struct Mode7{

		struct Pixel{
				ubyte r=0,g=0,b=0,a=0;
		}

		SDL_Surface* mSurface;
		Pixel[] mPixels;

		this(string bitmapFilePath){
				import std.string; // for toZString
													 // Create a texture
				mSurface = SDL_LoadBMP(bitmapFilePath.toStringz);
				for(int y=0; y < mSurface.h; y++){
						for(int x=0; x < mSurface.w; x++){
								SDL_LockSurface(mSurface);	
								ubyte* surface = cast(ubyte*)(mSurface.pixels);
								Pixel p;
								p.b = surface[y*mSurface.pitch + x*mSurface.format.BytesPerPixel+0];
								p.g = surface[y*mSurface.pitch + x*mSurface.format.BytesPerPixel+1];
								p.r = surface[y*mSurface.pitch + x*mSurface.format.BytesPerPixel+2];
//								p.a = data[y*mSurface.pitch + x*mSurface.format.BytesPerPixel+3];
								mPixels ~= p;

								SDL_UnlockSurface(mSurface);
						}
				}
		}

		~this(){
				SDL_FreeSurface(mSurface);
		}

		void DrawPoint(SDL_Renderer* renderer, int x, int y, int size, ubyte r, ubyte g, ubyte b,ubyte a){
				SDL_Rect rect;
				rect.x = x;
				rect.y = y;
				rect.w = size;
				rect.h = size;

				SDL_SetRenderDrawColor(renderer,r,g,b,a);
				SDL_RenderDrawRect(renderer,&rect);
		}
/*
		// Requires SDL 2.26.0 or above (i.e. add "versions:"["SDL_226"]) to the dub.json file.
		void DrawPointF(SDL_Renderer* renderer, float x, float y, ubyte r, ubyte g, ubyte b,ubyte a){
				SDL_FRect rect;
				rect.x = x;
				rect.y = y;
				rect.w = 2;
				rect.h = 2;

				SDL_SetRenderDrawColor(renderer,r,g,b,a);
				SDL_RenderFillRectF(renderer,&rect);
		}
*/
		void Render(SDL_Renderer* r, float camX, float camY, float camZ){
				for(int j=cast(int)camZ; j < mSurface.h+camZ; j++){
						for(int i=0; i < mSurface.w; i++){

								double focal_length = 250;
								double scale = 1000;
								double x = mSurface.w/2 - i;
								double y = j + focal_length;
								double z = j + 0.01;

								double px = x / z * scale;
								double py = camZ + y / z * scale;

								px = cast(int)(px+camX) % cast(int)(mSurface.w);
								py = cast(int)(py+camY) % cast(int)(mSurface.h);

								Pixel p = mPixels[(j)*mSurface.w + i];
								DrawPoint(r,cast(int)(px),cast(int)(py),2,p.r,p.g,p.b,p.a);
//								DrawPoint(r,i,j,1,p.r,p.g,p.b,p.a);
						}
				}
		}
}


// TODO: Remind students that floats are not initialized
struct Camera{
	float x=0,y=0,z=0;
}

struct GameApplication{
		SDL_Window* mWindow = null;
		SDL_Renderer* mRenderer = null;
		bool mGameIsRunning = true;
		
		// World Data
		Camera mCamera;

		// Game Data
		Sprite mySprite;
		Mode7 mMode7;

		// Constructor
		this(string title){
				// Create an SDL window
				mWindow = SDL_CreateWindow(title.toStringz, SDL_WINDOWPOS_UNDEFINED, 
																		SDL_WINDOWPOS_UNDEFINED, 
																		1280, 800, SDL_WINDOW_SHOWN);

				// Create a hardware accelerated mRenderer
				mRenderer = SDL_CreateRenderer(mWindow,-1,SDL_RENDERER_ACCELERATED);
				// Load the bitmap surface
				mySprite = Sprite(mRenderer,"./assets/images/test.bmp");

				mMode7 = Mode7("./assets/images/scale.bmp");
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
						if(event.type == SDL_QUIT){
								mGameIsRunning= false;
						}
				}

				ubyte* state = SDL_GetKeyboardState(null);
				float speed = 20.0f;
				if(state[SDL_SCANCODE_W]){
					mCamera.z+=speed;
				}
				if(state[SDL_SCANCODE_S]){
					mCamera.z-=speed;
				}
				if(state[SDL_SCANCODE_A]){
					mCamera.x+=speed;
				}
				if(state[SDL_SCANCODE_D]){
					mCamera.x-=speed;
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

				mMode7.Render(mRenderer,mCamera.x,mCamera.y,mCamera.z);
				mySprite.Render(mRenderer);

				// Final step is to present what we have copied into
				// video memory
				SDL_RenderPresent(mRenderer);
		}

		// Advance world one frame at a time
		void AdvanceFrame(){
				Input();
				Update();
				Render();
		}

		void RunLoop(){
				// Main application loop
				while(mGameIsRunning){
						AdvanceFrame();	
				}
		}
}
