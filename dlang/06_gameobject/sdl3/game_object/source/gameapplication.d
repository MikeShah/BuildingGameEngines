module gameapplication;
// Import D standard libraries
import std.stdio;
import std.string;

// Third-party libraries
import bindbc.sdl;

// Import our SDL Abstraction
import sdl_abstraction;
import sprite;
import collider_circle;

struct GameApplication{
		SDL_Window* mWindow = null;
		SDL_Renderer* mRenderer = null;
		bool mGameIsRunning = true;

		// Game Data
		Sprite mySprite;
		
		// Random circle collider
		ColliderCircle mCircle;

		// Constructor
		this(string title){
				// Create an SDL window
				mWindow = SDL_CreateWindow(title.toStringz, 640, 480, SDL_WINDOW_ALWAYS_ON_TOP);

				// Create a hardware accelerated mRenderer
				mRenderer = SDL_CreateRenderer(mWindow,null);
				// Load the bitmap surface
				mySprite = Sprite(mRenderer,"./assets/images/test.bmp");

				mCircle.radius = 50.0f;
				mCircle.x = 200;
				mCircle.y = 200;
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
				mySprite.mColliderCircle.IsColliding(mCircle);
				mySprite.Update();
		}

		void Render(){
				// Set the render draw color 
				SDL_SetRenderDrawColor(mRenderer,100,190,255,SDL_ALPHA_OPAQUE);
				// Clear the renderer each time we render
				SDL_RenderClear(mRenderer);

				mySprite.Render(mRenderer);

				mCircle.Render(mRenderer);
				
				// Final step is to present what we have copied into
				// video memory
				SDL_RenderPresent(mRenderer);
		}

		// Advance world one frame at a time
		void AdvanceFrame(){
				Input();
				Update();
				Render();
				SDL_Delay(200);
		}

		void RunLoop(){
				// Main application loop
				while(mGameIsRunning){
						AdvanceFrame();	
				}
		}
}
