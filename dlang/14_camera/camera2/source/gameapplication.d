/// @file: 
import std.conv, std.stdio, std.string;

import bindbc.sdl;
import gameobject;
import component;
import factory;
import linear;

struct Camera{
		mat3 mPosition;
}

struct SceneTree{
		GameObject[] mGameObjects;
		SDL_Renderer* mRendererRef;

		this(SDL_Renderer* r, int objects){
				mRendererRef = r;

				for(size_t i=0; i < objects; i++){
						// Create some different game objects from a factory
						if(i%2==0){
								mGameObjects ~= CreateTextureColliderGameObject("GameObject"~i.to!string);
						}else if(i==4){
								mGameObjects ~= MakeSprite("GameObject"~i.to!string);
						}
						else{
								mGameObjects ~= CreateTextureGameObject("GameObject"~i.to!string);
						}
				}


                // Make a bounding box
                GameObject world =  MakeBoundingBox("world"); 
                auto col = cast(ComponentCollision)world.GetComponent(ComponentType.COLLISION);
                col.mRect.w = 100;
                col.mRect.h = 400;

                mGameObjects ~= world;
		}

		void Input(){
		}

		void Update() {
				// Update components individually
				// Update texture components
				foreach(ref objComponent; mGameObjects){
						writeln(objComponent.GetName());
						auto tex = objComponent.GetComponent(ComponentType.TEXTURE);
						if(tex !is null){
								tex.Update();
						}
				}

				// Update Collision Components
				foreach(ref objComponent; mGameObjects){
						writeln(objComponent.GetName());
						auto col = objComponent.GetComponent(ComponentType.COLLISION);
						if(col !is null){
								col.Update();
						}
				}
		}

		void Render(){

				// Render Collision Components
				foreach(ref objComponent; mGameObjects){
						auto col = objComponent.GetComponent(ComponentType.COLLISION);
						if(col !is null){
								writeln(objComponent.GetName()," - collision render");
								col.Render(mRendererRef);
						}
				}
				// Render Texture Components
				foreach(ref objComponent; mGameObjects){
						auto tex = objComponent.GetComponent(ComponentType.TEXTURE);
						if(tex !is null){
								writeln(objComponent.GetName()," - texture render");
								tex.Render(mRendererRef);
						}
				}
			
		}
}

/// Store mappings of int, float, and strings to maps.
/// This data can keep track of various 'state' in your game and otherwise
/// be added to dynamically.
struct GameState{
	int[string] 		mIntMap;
	float[string] 	mFloatMap;
	string[string] 	mStringMap;

	void SaveToFile(string filename){
	}

	void loadFromFile(string filename){
	}
}

struct Scene{
		SceneTree    mSceneTree;
		Camera 			 mCamera;
		GameState		 mGameState;
		SDL_Renderer* mRendererRef;

		// Create scene with a new camera.
		this(SDL_Renderer* r, string jsonDataFile, Camera cam){
				mRendererRef = r;
				mCamera = cam;
				mSceneTree = SceneTree(mRendererRef,5);
		}
		void Input() {
			mSceneTree.Input();
		}
		void Update() {
			mSceneTree.Update();
		}
		void Render() {
			mSceneTree.Render();
		}
}

struct GameApplication{

		Scene[] mScenes;
		Scene   mActiveScene;
		bool mGameRunning=true;
		SDL_Renderer* mRenderer = null;

		this(string title){
				SDL_Window* window= SDL_CreateWindow(title.toStringz,
								SDL_WINDOWPOS_UNDEFINED,
								SDL_WINDOWPOS_UNDEFINED,
								640,
								480, 
								SDL_WINDOW_SHOWN);
				// Create a hardware accelerated renderer
				mRenderer = SDL_CreateRenderer(window,-1,SDL_RENDERER_ACCELERATED);

				mActiveScene = Scene(mRenderer,"scene.json",Camera());
		}

		void Input() {
				mActiveScene.Input();
				// (1) Handle Input
				SDL_Event event;
				// Start our event loop
				while(SDL_PollEvent(&event)){
						// Handle each specific event
						if(event.type == SDL_QUIT){
								mGameRunning= false;
						}
				}
				// Get Keyboard input
				const ubyte* keyboard = SDL_GetKeyboardState(null);
				// Check for movement
				if(keyboard[SDL_SCANCODE_LEFT] ){ 
				}
				if(keyboard[SDL_SCANCODE_RIGHT]){
				}
				if(keyboard[SDL_SCANCODE_UP] ){
				}
				if(keyboard[SDL_SCANCODE_DOWN]){
				}

		}
		void Update() {
				mActiveScene.Update();
		}
		void Render() {
				SDL_SetRenderDrawColor(mRenderer,100,190,255,SDL_ALPHA_OPAQUE);
				SDL_RenderClear(mRenderer);

				mActiveScene.Render();

				// Finally show what we've drawn
				// (i.e. anything where we have called SDL_RenderCopy will be in memory and presnted here)
				SDL_RenderPresent(mRenderer);
		}

		void AdvanceFrame(){
				Input();
				Update();
				Render();	
		}

		void RunLoop(){
				while(mGameRunning){
						// Little frame capping hack so we don't run too fast
						SDL_Delay(125);
						AdvanceFrame();
				}
		}

}
