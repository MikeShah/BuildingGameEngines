// @file manager.d
struct Image{
	string filename;
	ubyte[] pixels;
}

struct ResourceManager{							// Resource manager is
	Image* LoadImageResource(string filename){  // essentially a key/value
		if(filename in mImageResourceMap){		// in-memory database for 
			return mImageResourceMap[filename];	// resources that you want
		}else{									// to keep-alive or otherwise
			return null;						// expliciltly manage.
		}
	}
	private:
	Image*[string] mImageResourceMap;			// Built-in unordered assoc. array
}

struct AppState{		// App specific state/resources collected in one place	
	ResourceManager* mManager = new ResourceManager;
}

struct GameApplication{
	// Stuff specific to window
	// SDL_Window ... SDL_Renderer ... etc.
	
	// State that could be passed along, including resource manager.
	AppState mAppState;

	void MainLoop(){ /* */}
}

void main(){
	GameApplication app;
	app.mAppState.mManager.LoadImageResource("myImage.bmp");
}
