/// @file: 
import std.conv, std.stdio, std.string;

import bindbc.sdl;
import gameobject;
import component;
import factory;
import linear;
import scripts;

/// Camera has a transformation
class Camera{
    ComponentTransform mTransform;
    this(){
        mTransform = new ComponentTransform(0);
    }

    void PositionCamera(float x, float y){
        mTransform.mLocalMatrix = MakeTranslate(x,y);
    }
    Vec2f GetPosition(){
        Vec2f result = mTransform.mLocalMatrix.Frommat3GetTranslation();
        return result;
    }
}

struct SceneTree{
    GameObject[] mGameObjects;
    SDL_Renderer* mRendererRef;

    this(SDL_Renderer* r, int objects){
        mRendererRef = r;

				LoadWorld(5);
    }

		// TODO: This is really just a helper function
		//       It probably belongs in 'Scene' to othrwise
		//       access and 'add to the scene tree' as a function of input.
		GameObject MakeAsteroidBox(string name,int x, int y){
				GameObject obj = MakeSprite(name);
				auto transform= cast(ComponentTransform)obj.GetComponent(ComponentType.TRANSFORM);
				auto tex = cast(ComponentTexture)obj.GetComponent(ComponentType.TEXTURE);
				auto col  = cast(ComponentCollision)obj.GetComponent(ComponentType.COLLISION);
				tex.mRect.w = 50;
				tex.mRect.h = 50;
				col.mRect.w = 50;
				col.mRect.h = 50;
				transform.Translate(x,y);
				obj.mScripts ~= new AsteroidScript(obj.GetID());

				return obj;
		}

		// TODO: No filename or format to parse
		void LoadWorld(int objects){
            // Create some different game objects from a factory
				// Perhaps representing asteroids
        for(size_t i=0; i < objects; i++){
            mGameObjects ~= MakeAsteroidBox("GameObject"~i.to!string,60*cast(int)i,10);
        }

        // Make the main character
        GameObject player = MakeSprite("MainPlayer");
        player.mScripts ~= new PlayerScript(player.GetID());
        auto transform= cast(ComponentTransform)player.GetComponent(ComponentType.TRANSFORM);
        auto tex = cast(ComponentTexture)player.GetComponent(ComponentType.TEXTURE);
        auto col  = cast(ComponentCollision)player.GetComponent(ComponentType.COLLISION);
        tex.mRect.w = 50;
        tex.mRect.h = 50;
        col.mRect.w = 50;
        col.mRect.h = 50;
        mGameObjects ~= player;

        // Make a bounding box to represent the world
        GameObject world =  MakeBoundingBox("world"); 
        auto collider= cast(ComponentCollision)world.GetComponent(ComponentType.COLLISION);
        collider.mRect.x = 0;
        collider.mRect.y = 0;
        collider.mRect.w = 800;
        collider.mRect.h = 600;

        mGameObjects ~= world;
		}

		// TODO: Consider moving this elsewhere
		void Input(Camera cam){
				// Get SDL Mouse coordinates
				float mouseX, mouseY;
				int mask = SDL_GetMouseState(&mouseX,&mouseY);
				Vec2f cameraPosition=cam.GetPosition();

				if(mask == SDL_BUTTON_LEFT){
						int newX = cast(int)mouseX - cast(int)cameraPosition.x;
						int newY = cast(int)mouseY - cast(int)cameraPosition.y;
						mGameObjects ~= MakeAsteroidBox("asteroid"~mGameObjects.length.to!string,newX,newY); 
						// Cheap delay after a mouse click
						// Better to handle the state, but this is fine for now.
						SDL_Delay(200);
				}
		}

    // TODO
    // Note that this is not quite correct, meaning that we should update all of
    // the transforms first, and perform the Depth-First Traversal
    void Update(Camera cam) {

        // Get the main player
        GameObject go = GameObject.GetGameObject("MainPlayer");
        // Set the camera to center on the main player
        auto playerTransform= cast(ComponentTransform)go.GetComponent(ComponentType.TRANSFORM);
        Vec2f xy = playerTransform.mLocalMatrix.Frommat3GetTranslation();
        cam.PositionCamera(-xy.x+100,-xy.y+100);

        // Update scripts
        foreach(ref o ; mGameObjects){
            foreach(ref scripts; o.mScripts){
                scripts.Update();
            }
        }

        // Update Transform components
        foreach(ref objComponent; mGameObjects){
            auto transform = cast(ComponentTransform)objComponent.GetComponent(ComponentType.TRANSFORM);
            transform.mWorldMatrix = transform.mLocalMatrix * cam.mTransform.mLocalMatrix; 

            if(transform !is null){
                transform.Update();
            }
        }
    }

    void Render(){        
        // Render Collision Components
        foreach(ref objComponent; mGameObjects){
            auto col = cast(ComponentCollision)objComponent.GetComponent(ComponentType.COLLISION);
            if(col !is null){
                writeln(objComponent.GetName()," - collision render");
                col.Render(mRendererRef);
                auto transform = cast(ComponentTransform)objComponent.GetComponent(ComponentType.TRANSFORM);
                Vec2f pos = transform.mWorldMatrix.Frommat3GetTranslation() ;
                col.mRect.x = cast(int)pos.x;
                col.mRect.y = cast(int)pos.y;
            }
        }
        // Render Texture Components
        foreach(ref objComponent; mGameObjects){
            auto tex = cast(ComponentTexture)objComponent.GetComponent(ComponentType.TEXTURE);
            if(tex !is null){
                writeln(objComponent.GetName()," - texture render");
                tex.Render(mRendererRef);
                
                auto transform = cast(ComponentTransform)objComponent.GetComponent(ComponentType.TRANSFORM);
								Vec2f pos = transform.mWorldMatrix.Frommat3GetTranslation() ;
                writeln(tex.mRect);
                tex.mRect.x = cast(int)pos.x;
                tex.mRect.y = cast(int)pos.y;
                writeln(tex.mRect);
            }
        }

    }
}

/// Store mappings of int, float, and strings to maps.
/// This data can keep track of various 'state' in your game and otherwise
/// be added to dynamically.
struct GameState{
    int[string]     mIntMap;
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
		IScript[]		mSceneScripts; 

    // Create scene with a new camera.
    this(SDL_Renderer* r, string jsonDataFile, Camera cam){
        mRendererRef = r;
        mCamera = cam;
        mSceneTree = SceneTree(mRendererRef,5);
    }
    void Input() {
        mSceneTree.Input(mCamera);
    }
    void Update() {
				foreach(ref s; mSceneScripts){
					s.Update();
				}

        mSceneTree.Update(mCamera);
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
                640,
                480, 
                SDL_WINDOW_ALWAYS_ON_TOP);
        // Create a hardware accelerated renderer
        mRenderer = SDL_CreateRenderer(window,null);

        mActiveScene = Scene(mRenderer,"scene.json",new Camera());
    }

    void Input() {
        mActiveScene.Input();
        // (1) Handle Input
        SDL_Event event;
        // Start our event loop
        while(SDL_PollEvent(&event)){
            // Handle each specific event
            if(event.type == SDL_EVENT_QUIT){
                mGameRunning= false;
            }
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
        writeln("=============Start Frame===============");
        Input();
        Update();
        Render();	
        writeln("--------------End Frame----------------");
    }

    void RunLoop(){
        while(mGameRunning){
            // TODO: Implement proper frame capping
            SDL_Delay(16);
            AdvanceFrame();
        }
    }

}
