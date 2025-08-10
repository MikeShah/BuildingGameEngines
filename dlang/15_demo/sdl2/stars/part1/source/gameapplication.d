module gameapplication;
// Import D standard libraries
import std.stdio;
import std.string;
import std.math;

// Third-party libraries
import bindbc.sdl;

// Import our SDL Abstraction
import sdl_abstraction;
import objectmanager;
import component;
import gameobject;
import factory;
import matrix;
import transform;
// Import from our own project dependencies
import vec2;


static struct Camera{
	static Mat3 mMat3;

	static	void MoveUp(){
		mMat3 = mMat3.Translate(0.0f,10.0f);
	}
	static	void MoveDown(){
		mMat3 = mMat3.Translate(0.0f,-10.0f);
	}

	static Mat3 GetViewTransform(){
		return mMat3;
	}

	static Vec2f GetCameraPosition(){
		return FromMat3GetTranslation(mMat3);
	}

}


// Main game application
struct GameApplication{
	SDL_Window* mWindow = null;
	SDL_Renderer* mRenderer = null;
	bool mGameIsRunning = true;
	// For convenience store mouseX and mouseY
	int mMouseX,mMouseY;

	// Constructor
	this(string title){
		// Create an SDL window
		mWindow = SDL_CreateWindow(title.toStringz, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 640, 480, SDL_WINDOW_SHOWN);

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

		ubyte* keys = SDL_GetKeyboardState(null);
		if(keys[SDL_SCANCODE_UP]){
			Camera.MoveUp();
		}
		if(keys[SDL_SCANCODE_DOWN]){
			Camera.MoveDown();
		}


		// Handle mouse clicks
		// mouse positions x and y are stored in local variables
		uint mask = SDL_GetMouseState(&mMouseX,&mMouseY);

		// When we left click, let's create a new object
		if(mask == SDL_BUTTON_LEFT){
			writeln("New sprite");
			// Create the game object
			GameObject go = MakeSprite("GameObjectSprite");

			// Grab the texture component
			auto tex = cast(ComponentTexture)go.GetComponent(ComponentType.TEXTURE);
			tex.LoadTexture(mRenderer,"./assets/images/star.bmp");
			// Grab a specific component from the game object
			auto comp = cast(ComponentTransform)go.GetComponent(ComponentType.TRANSFORM);
			// Retrieve the matrix in the transform component to perform transformations
			auto t = comp.GetMat3();

			// Update Mouse coordinates to world position
			Vec2f camPos = Camera.GetCameraPosition();
			int mouseWorldX = mMouseX + cast(int)camPos.x;
			int mouseWorldY = mMouseY + cast(int)camPos.y;

			// Compute the world coordinate from the mouse position
			Vec2f world = ScreenToWorld(mouseWorldX,mouseWorldY,640,480);

			// Scale and translate
			t=t.Translate(world.x,world.y).Scale(50.0f,50.0f);

			// Update the component
			comp.SetMat3(t);
			// Append game object to our list of game objects
			ObjectManager.AddGameObject(go);
			// Cheap delay after a mouse click
			// Better to handle the state, but this is fine for now.
			SDL_Delay(200);
		}
	}

	void Update(){
		// Update any of our game objects
		ObjectManager.Update!(ComponentType.TRANSFORM)();
		ObjectManager.Update!(ComponentType.CIRCLE_COLLIDER)();
		ObjectManager.Update!(ComponentType.TEXTURE)();
	}

	void Render(){
		// Set the render draw color 
		SDL_SetRenderDrawColor(mRenderer,100,190,255,SDL_ALPHA_OPAQUE);
		// Clear the renderer each time we render
		SDL_RenderClear(mRenderer);
		// Default Line drawing color 
		SDL_SetRenderDrawColor(mRenderer,255,0,0,SDL_ALPHA_OPAQUE);

		// Render any of our game Objects
		ObjectManager.Render!(ComponentType.TRANSFORM)(mRenderer);
		ObjectManager.Render!(ComponentType.CIRCLE_COLLIDER)(mRenderer);
		ObjectManager.Render!(ComponentType.TEXTURE)(mRenderer);

		// ================= Mouse in World Space Usage ==================
		// Let's create our 'mouse' in worldSpace. This can be useful if we want
		// to trigger events in the game world right at the worldSpace position.
		// We can convert back to screen coordinates if we need whenever.

		Vec2f mouseWorld = ScreenToWorld(cast(float)mMouseX,cast(float)mMouseY,640,480);
//		writeln("mouse screen coordiantes: ",mMouseX,",",mMouseY);
//		writeln("mouse world coordiante:",mouseWorld);

		// Draw a line from the origin to the mouse world space coordinate
		DrawLine(Vec2f(0.0f,0.0f),mouseWorld);
		SDL_SetRenderDrawColor(mRenderer,0,0,255,SDL_ALPHA_OPAQUE);
		// ==========================================================

		// Final step is to present what we have copied into
		// video memory
		SDL_RenderPresent(mRenderer);
	}

	// Advance world one frame at a time
	void AdvanceFrame(){
		Input();
		Update();
		Render();
		SDL_Delay(50);
	}

	void RunLoop(){
		// Main application loop
		while(mGameIsRunning){
			AdvanceFrame();	
		}
	}

	// Handy function that maps our world coordinates that we supply back to
	// screen coordinates. 
	// We use this function whenever we want to draw something to the screen where 
	// we are already in world coordinates.
	auto DrawLine(Vec2f a, Vec2f b) {
		a = WorldToScreenCoordinates(a.x,a.y,640,480);
		b = WorldToScreenCoordinates(b.x,b.y,640,480);
		SDL_RenderDrawLine(mRenderer,cast(int)a.x,cast(int)a.y,cast(int)b.x,cast(int)b.y); 
	}
}
