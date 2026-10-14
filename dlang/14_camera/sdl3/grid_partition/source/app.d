/// @file: grid_partition/app.d
import std.stdio, std.string, std.datetime.stopwatch, std.conv;
import sdl_abstraction;
import bindbc.sdl;

// Store the application state
class AppState{
  SDL_Window* mWindow;
  SDL_Renderer* mRenderer;

  ~this(){
    // Destroy our renderer
    SDL_DestroyRenderer(mRenderer);
    // Destroy our window
    SDL_DestroyWindow(mWindow);
  }
}

// The scene
class Scene{
  Sprite[] mSprites;
  Partition[] mPartitions;

  void CreateScene(AppState app,size_t sprites){
    import std.random;
    auto rnd = Random(unpredictableSeed);

    for(size_t i =0; i < sprites; i++){
      Sprite s= new Sprite(app,uniform(0,640),uniform(0,480));
      s.yUp = cast(bool)uniform(0,2);
      s.xUp = cast(bool)uniform(0,2);
      mSprites ~=s;
    }

    // Create '4' separate partiions
    mPartitions ~= new Partition(0,0,320,240);
    mPartitions ~= new Partition(320,0,320,240);
    mPartitions ~= new Partition(0,240,320,240);
    mPartitions ~= new Partition(320,240,320,240);
  }

  void Render(AppState app){
    // Move all the sprites randomly for the purpose of this demo
    for(size_t i=0; i < mSprites.length; i++){
      with(mSprites[i]){
        if(mRectangle.y<0) {yUp=true;}
        if(mRectangle.y>480) {yUp=false;}
        if(mRectangle.x<0) {xUp=true;}
        if(mRectangle.x>640) {xUp=false;}

        if(yUp){mRectangle.y++;}else{mRectangle.y--;};
        if(xUp){mRectangle.x++;}else{mRectangle.x--;};
      }
    }


    for(size_t i=0; i < mSprites.length; i++){
      mSprites[i].Render(app);
    }
  }

  void HandleCollision(){
    for(int a=0; a < mSprites.length; a++){
      for(int b=0; b < mSprites.length; b++){
        if(a==b){continue;}
        // Test if a collision happened
        if(SDL_HasRectIntersectionFloat(&mSprites[a].mRectangle, &mSprites[b].mRectangle)){
        }
      }
    }
  }

  void HandleCollisionPartitioned(){
    // Update the sets
    for(int i=0; i < mPartitions.length; i++){
      for(int a=0; a < mSprites.length; a++){
        mPartitions[i].TestAndUpdateSet(mSprites[a]);
      }
    }

    // Handle collisions in each set
    for(int i=0; i < mPartitions.length; i++){
     mPartitions[i].HandleCollisionPartitioned();
    }

    // Reset all of the partitions each frame
    for(int i=0; i < mPartitions.length; i++){
      mPartitions[i].Reset();
    }
    
  }



}


class Partition{
  SDL_FRect mBoundary;
  Sprite[] mCollection;

  // Setup a partioin
  this(float x, float y, float w, float h){
    mBoundary.x = x;
    mBoundary.y = y;
    mBoundary.w = w;
    mBoundary.h = h;
  }

  void TestAndUpdateSet(Sprite s){
    if(SDL_HasRectIntersectionFloat(&mBoundary, &s.mRectangle)){
      mCollection ~= s;
    }
  }

  // NOTE: This is a really 'cheap' but inefficient way to handle collisions,
  //       in the sense that I update the collection every frame.
  void Reset(){
    // Empty the collection
    mCollection = [];
  }

  void HandleCollisionPartitioned(){
    for(int a=0; a < mCollection.length; a++){
      for(int b=0; b < mCollection.length; b++){
        if(a==b){continue;}
        // Test if a collision happened
        if(SDL_HasRectIntersectionFloat(&mCollection[a].mRectangle, &mCollection[b].mRectangle)){
        }
      }
    }
  }
}




class Sprite{
  SDL_FRect mRectangle;
  SDL_Texture* mTexture;
  bool xUp;
  bool yUp;

  this(AppState app,float x,float y){
    // Load the bitmap surface
    SDL_Surface* myTestImage   = SDL_LoadBMP("./assets/images/test.bmp");
    // Create a texture from the surface
    mTexture = SDL_CreateTextureFromSurface(app.mRenderer,myTestImage);
    // Done with the bitmap surface pixels after we create the texture, we have
    // effectively updated memory to GPU texture.
    SDL_DestroySurface(myTestImage);
    // Rectangle is where we will represent the shape.
    mRectangle.x = x;
    mRectangle.y = y;
    mRectangle.w = 20;
    mRectangle.h = 20;
  }

  void Render(AppState app){
      // Copy a texture (or portion of a texture) to another
      // portion of video memory (i.e. a 2D grid of texels 
      // which span the width and height of the window)
      SDL_RenderTexture(app.mRenderer,mTexture,null,&mRectangle);
  }

  ~this(){
    // Free Video Memory
    SDL_DestroyTexture(mTexture);
  }

}

// Entry point 
struct GameApplication{
  AppState mAppState;
  Scene    mScene;

  this(string title, int sprites=5){
    mAppState = new AppState;
    // Create na SDL Window
    mAppState.mWindow = SDL_CreateWindow(title.toStringz,640,480, SDL_WINDOW_ALWAYS_ON_TOP);
    // Create a hardware accelerated mRenderer
    mAppState.mRenderer = SDL_CreateRenderer(mAppState.mWindow,null);

    // Create a new scene
    mScene = new Scene;
    mScene.CreateScene(mAppState,sprites);
  }

  void MainLoop(){
    int frameCount=0;
    auto sw = StopWatch(AutoStart.yes);
    sw.start();
    // Infinite loop for our application
    bool gameIsRunning=true;
    int NaiveCollision=1;

    while(gameIsRunning){
      frameCount++;
      if(sw.peek.total!"msecs" > 1000){
        SDL_SetWindowTitle(mAppState.mWindow,("Spatial partiioning demo: (FPS="~frameCount.to!string ~ ") NaiveCollision="~NaiveCollision.to!string).toStringz);
        sw.reset();
        frameCount=0;
      }
      // Store an SDL Event
      SDL_Event event;
      // Handle input from our polled event.
      // Event is stored in the structure."q
      while(SDL_PollEvent(&event)){
        if(event.type == SDL_EVENT_QUIT){
          writeln("Exit event triggered");
          gameIsRunning= false;
        }
        if(event.type == SDL_EVENT_KEY_DOWN){
          if(NaiveCollision==0){
            NaiveCollision=1;
          }else if(NaiveCollision==1){
            NaiveCollision=0;
          }
        }
      }
      // Set the render draw color 
      SDL_SetRenderDrawColor(mAppState.mRenderer,100,190,255,SDL_ALPHA_OPAQUE);
      // Clear the renderer each time we render
      SDL_RenderClear(mAppState.mRenderer);

      mScene.Render(mAppState);
      if(NaiveCollision==1){
        mScene.HandleCollision();
      }else{
        mScene.HandleCollisionPartitioned();
      }

      // Final step is to present what we have copied into
      // video memory
      SDL_RenderPresent(mAppState.mRenderer);
    }
  }

}

void main(string[] args){
  if(args.length < 2){
    writeln("============== READ ===============");
    writeln("Re-run with ./prog 400 or dub -- 400");
    writeln("The second argument is the number of sprites");
    return;
  }
  GameApplication app = GameApplication("Spatial Partitioning demo",args[1].to!int);
  app.MainLoop();
} // end main()
