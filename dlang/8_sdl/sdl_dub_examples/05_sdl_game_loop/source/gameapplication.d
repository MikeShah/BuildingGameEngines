module gameapplication;
// Import D standard libraries
import std.stdio;
import std.string;

// Third-party libraries
import bindbc.sdl;

// Import our SDL Abstraction
import sdl_abstraction;

struct GameApplication{
		SDL_Window* mWindow = null;
		SDL_Renderer* mRenderer = null;
		bool mGameIsRunning = true;

		// Game Data
		SDL_Rect rectangle;
		SDL_Surface* myTestImage;
		SDL_Texture* texture;

		// Constructor
		this(string title){
				// Create an SDL window
				mWindow = SDL_CreateWindow(title.toStringz, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 640, 480, SDL_WINDOW_SHOWN);

				// Create a hardware accelerated mRenderer
				mRenderer = SDL_CreateRenderer(mWindow,-1,SDL_RENDERER_ACCELERATED);
				// Load the bitmap surface
				myTestImage   = SDL_LoadBMP("./assets/images/test.bmp");
				// Create a texture from the surface
				texture = SDL_CreateTextureFromSurface(mRenderer,myTestImage);
				// Done with the bitmap surface pixels after we create the texture, we have
				// effectively updated memory to GPU texture.
				SDL_FreeSurface(myTestImage);
		}

		// Destructor
		~this(){
				// Free Video Memory
				SDL_DestroyTexture(texture);
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
		}

		void Update(){
				static int x =0;
				static int y =0;
				static int xDirection=1;
				static int yDirection=1;
				
				if(xDirection==1){ ++x; }
				else if(xDirection==-1){ --x; }

				if(yDirection==1){ ++y; }
				else if(yDirection==-1){ --y; }
				
				if(rectangle.x > 540){xDirection=-1;}
				if(rectangle.x < 0){xDirection=1;}
				if(rectangle.y > 380){yDirection=-1;}
				if(rectangle.y < 0){yDirection=1;}
			
				rectangle.x = 50+ x;
				rectangle.y = 50+ y;
				rectangle.w = 100;
				rectangle.h = 100;
		}

		void Render(){
				// Set the render draw color 
				SDL_SetRenderDrawColor(mRenderer,100,190,255,SDL_ALPHA_OPAQUE);
				// Clear the renderer each time we render
				SDL_RenderClear(mRenderer);

				// Copy a texture (or portion of a texture) to another
				// portion of video memory (i.e. a 2D grid of texels 
				// which span the width and height of the window)
				SDL_RenderCopy(mRenderer,texture,null,&rectangle);

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
