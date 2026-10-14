/// @file: grid_partition/app.d
// This demonstrates how to do grid partitioning with a fixed-size grid.
import std.stdio, std.string, std.datetime.stopwatch, std.conv;
import sdl_abstraction;
import bindbc.sdl;
import sprite, appstate;


// The scene
class Scene{
  Sprite[] mSprites;
  Partition[] mPartitions;

  void CreateScene(AppState app,size_t sprites, int partitions){
    import std.random;
    auto rnd = Random(unpredictableSeed);

    for(size_t i =0; i < sprites; i++){
      Sprite s= new Sprite(app,uniform(0,640),uniform(0,480));
      s.yUp = cast(bool)uniform(0,2);
      s.xUp = cast(bool)uniform(0,2);
      mSprites ~=s;
    }

    // Create '4' separate partiions manually
    /*
    mPartitions ~= new Partition(0,0,320,240);
    mPartitions ~= new Partition(320,0,320,240);
    mPartitions ~= new Partition(0,240,320,240);
    mPartitions ~= new Partition(320,240,320,240);
*/
    // You can try with '16' partitions as well to see if you
    // get better performance
    // NOTE: We are assuming a 640x480 sized window
    int xSize = 640/partitions;
    int ySize = 480/partitions;
    for(int y=0; y < partitions; y++){
      for(int x=0; x < partitions; x++){
        mPartitions ~= new Partition(x*xSize,y*ySize,xSize,ySize);
      }
    }
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


  void HandleCollisionNaive(AppState app){
    for(int a=0; a < mSprites.length; a++){
      for(int b=0; b < mSprites.length; b++){
        if(a==b){continue;}
        // Test if a collision happened
        if(SDL_HasRectIntersectionFloat(&mSprites[a].mRectangle, &mSprites[b].mRectangle)){
          SDL_RenderRect(app.mRenderer,&mSprites[a].mRectangle);
        }
      }
    }
  }

  void HandleCollisionPartitioned(AppState app){
    // NOTE: If you want you can handle resetting the partitions less frequently
    //       or only for objects as they 'move'.
    //    
    ResetPartitions();

    // Handle collisions in each set
    for(int i=0; i < mPartitions.length; i++){
     mPartitions[i].HandleCollisionPartitioned(app);
    }  
  }

  // Resets the object partitions
  void ResetPartitions(){
    // Reset all of the partitions each frame
    for(int i=0; i < mPartitions.length; i++){
      mPartitions[i].Reset();
    }
    // Update the sets
    for(int i=0; i < mPartitions.length; i++){
      for(int a=0; a < mSprites.length; a++){
        mPartitions[i].TestAndUpdateSet(mSprites[a]);
      }
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

  void HandleCollisionPartitioned(AppState app){

    SDL_SetRenderDrawColor(app.mRenderer,255,255,255,255);
    SDL_RenderRect(app.mRenderer,&mBoundary);
    SDL_SetRenderDrawColor(app.mRenderer,255,0,0,255);


    for(int a=0; a < mCollection.length; a++){
      for(int b=0; b < mCollection.length; b++){
        if(a==b){continue;}
        // Test if a collision happened
        if(SDL_HasRectIntersectionFloat(&mCollection[a].mRectangle, &mCollection[b].mRectangle)){
          SDL_RenderRect(app.mRenderer,&mCollection[a].mRectangle);
        }
      }
    }
  }
}




// Entry point 
struct GameApplication{
  AppState mAppState;
  Scene    mScene;

  this(string title, int sprites, int partitions){
    mAppState = new AppState;
    // Create na SDL Window
    mAppState.mWindow = SDL_CreateWindow(title.toStringz,640,480, SDL_WINDOW_ALWAYS_ON_TOP);
    // Create a hardware accelerated mRenderer
    mAppState.mRenderer = SDL_CreateRenderer(mAppState.mWindow,null);

    // Create a new scene
    mScene = new Scene;
    assert(partitions> 0, "Partiions must be greater than 0");
    mScene.CreateScene(mAppState,sprites, partitions);
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
        SDL_SetWindowTitle(mAppState.mWindow,("Spatial partition demo: (FPS="~frameCount.to!string ~ ") NaiveCollision="~NaiveCollision.to!string).toStringz);
        sw.reset();
        frameCount=0;

        // NOTE:
        // You can try some tricks to update your grid less often, like either
        // doing this fewer times per frame, or only when objects move.
//        if(NaiveCollision==0){
//          mScene.ResetPartitions();
//        }
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
        mScene.HandleCollisionNaive(mAppState);
      }else{
        mScene.HandleCollisionPartitioned(mAppState);
      }

      // Final step is to present what we have copied into
      // video memory
      SDL_RenderPresent(mAppState.mRenderer);
    }
  }

}

void main(string[] args){
  if(args.length < 3){
    writeln("============== READ ===============");
    writeln("Re-run with ./prog 400 4 or dub -- 400 4");
    writeln("The first argument is the number of sprites");
    writeln("The second argument is the number of partiions (2=2x2, 4=4x4");
    return;
  }
  GameApplication app = GameApplication("Spatial Partitioning demo",args[1].to!int, args[2].to!int);
  app.MainLoop();
} // end main()
