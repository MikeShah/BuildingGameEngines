module gameapplication;
// Import D standard libraries
import std.stdio;
import std.string;

// Third-party libraries
import sdl_manual_binding;

// Import our SDL Abstraction
struct GameApplication{
		SDL_Window* mWindow = null;
		SDL_Renderer* mRenderer = null;
		bool mGameIsRunning = true;

		// Constructor
		this(string title){
				// Create an SDL window
				mWindow= SDL_CreateWindow(title.toStringz, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 640, 480, SDL_WINDOW_SHOWN);

				// Create a hardware accelerated mRenderer
				mRenderer = SDL_CreateRenderer(mWindow,-1,SDL_RENDERER_ACCELERATED);
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
		}

		void Update(){
		}

		void Render(){
				// Load the bitmap surface
				SDL_Surface* myTestImage   = SDL_LoadBMP("./assets/images/test.bmp");
				// Create a texture from the surface
				SDL_Texture* texture = SDL_CreateTextureFromSurface(mRenderer,myTestImage);
				// Done with the bitmap surface pixels after we create the texture, we have
				// effectively updated memory to GPU texture.
				SDL_FreeSurface(myTestImage);

				// Rectangle is where we will represent the shape
				SDL_Rect rectangle;
				rectangle.x = 50;
				rectangle.y = 50;
				rectangle.w = 100;
				rectangle.h = 100;

				// (3) Clear and Draw the Screen
				// Gives us a clear "canvas"
				SDL_SetRenderDrawColor(mRenderer,100,190,255,SDL_ALPHA_OPAQUE);
				SDL_RenderClear(mRenderer);

				// Draw our shape
				SDL_RenderCopy(mRenderer,texture,null,&rectangle);
				// Finally show what we've drawn
				SDL_RenderPresent(mRenderer);
		}

		// 
		void AdvanceFrame(){
				// (2) Handle Updates
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