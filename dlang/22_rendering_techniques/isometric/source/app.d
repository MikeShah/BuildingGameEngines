/// @file: app.d
import std.stdio, std.algorithm;
import sdl_abstraction;
import bindbc.sdl;

struct Sprite{

  SDL_Texture*  mTexture;
  SDL_FRect     mRectangle;
  SDL_FRect     mSourceRectangle;
  int mZOrder = 0;


  this(SDL_Renderer* renderer, string bitmapFilePath, float x, float y, float w, float h, int zIndex){
    import std.string; // for toZString
                       // Create a texture
    SDL_Surface* mSurface = SDL_LoadBMP(bitmapFilePath.toStringz);
    mTexture = SDL_CreateTextureFromSurface(renderer,mSurface);
    SDL_DestroySurface(mSurface);
    // Position the rectangle 
    mRectangle.x = x;
    mRectangle.y = y;
    mRectangle.w = w;
    mRectangle.h = h;
    // Set source rectangle to be 'empty' or 'null'
    mSourceRectangle.x =0;
    mSourceRectangle.y =0;
    mSourceRectangle.w =0;
    mSourceRectangle.h =0;

    // 'z-order' is the order in which the Sprite should be drawn
    mZOrder = zIndex;
  }

  // Destroy anything 'heap' allocated.
  // Remember, SDL is a C library, thus heap allocated resources need
  // to be destroyed
  ~this(){
    SDL_DestroyTexture(mTexture);
  }

  void Input(){}
  void Update(){}

  void MoveSprite(float x, float y){
    mRectangle.x = x;
    mRectangle.y = y;
  }

  void SetSourceRectangle(float x, float y, float w, float h){
    mSourceRectangle.x =x;
    mSourceRectangle.y =y;
    mSourceRectangle.w =w;
    mSourceRectangle.h =h;
  }

  void Render(SDL_Renderer* renderer){
    // Copy a texture (or portion of a texture) to another
    // portion of video memory (i.e. a 2D grid of texels 
    // which span the width and height of the window)
    if(mSourceRectangle.w ==0 && mSourceRectangle.h ==0){
      SDL_RenderTexture(renderer,mTexture,null,&mRectangle);
    }else{
      SDL_RenderTexture(renderer,mTexture,&mSourceRectangle,&mRectangle);
    }
  }
}

struct Iso{
  float x,y;
}
// Converts an 'x' coordinate into an isometric screen-space coordinate.
// NOTE: Normally you could simply encode this into part of your matrix transformation
//       for the translation step.
// NOTE: Depending on the ratio of tile width the tile height, you may need to adjust
//       this conversion function.
//       This is tested for tiles that are the same height and width.
Iso toIsometric(float x, float y){
  Iso result;

  enum tile_width = 32;
  enum tile_height= 32;

  result.x = (x*tile_width/2) + (y*tile_width / 2);
  result.y = 250+ (y*tile_height/4) - (x*tile_height / 4);

  return result;
}

void main()
{
  SDL_Window* window = SDL_CreateWindow("Dlang SDL Mike Isometric", 640,480, SDL_WINDOW_ALWAYS_ON_TOP);

  // Create a hardware accelerated mRenderer
  SDL_Renderer* renderer = SDL_CreateRenderer(window,null);

  // Perform the 'translation' to isometric coordinates
  Sprite[] tiles;

  for(int y=0; y < 20; y++){
    for(int x=20; x > -1; x--){
      Iso coordinate = toIsometric(x,y);
      // Optionally add some sort of 'order' or zOrder.
      int order =0;
      writeln(x,",",y,"=",coordinate,"\twith order: ",order);
      if(x%5 == 0 || y %5 ==0 || y==19){
        tiles ~= Sprite(renderer,"./assets/images/tile_001.bmp",coordinate.x,coordinate.y,32,32,order);
      }else{
        tiles ~= Sprite(renderer,"./assets/images/tile_024.bmp",coordinate.x,coordinate.y,32,32,order);
      }
    }
  }

  // Store mouse positions
  float mouseX,mouseY;

  bool gameIsRunning=true;
  while(gameIsRunning){
    // Store an SDL Event
    SDL_Event event;
    while(SDL_PollEvent(&event)){
      if(event.type == SDL_EVENT_QUIT){
        writeln("Exit event triggered");
        gameIsRunning= false;
      }
      if(event.type == SDL_EVENT_KEY_DOWN){
        writeln("Pressed a key ");
      }
    }
    SDL_GetMouseState(&mouseX,&mouseY);

    // Update our sprite
    foreach(ref tile; tiles){
      tile.Update();
    }

    // Set the render draw color 
    SDL_SetRenderDrawColor(renderer,100,190,255,SDL_ALPHA_OPAQUE);
    // Clear the renderer each time we render
    SDL_RenderClear(renderer);

    foreach(ref tile; tiles){
      tile.Render(renderer);
      //SDL_Delay(30); // Uncomment to get the animation
      //SDL_RenderPresent(renderer);
    }

    // Final step is to present what we have copied into
    // video memory
    SDL_RenderPresent(renderer);
  }
  // Destroy our renderer
  SDL_DestroyRenderer(renderer);
  // Destroy our window
  SDL_DestroyWindow(window);
} // end main()
