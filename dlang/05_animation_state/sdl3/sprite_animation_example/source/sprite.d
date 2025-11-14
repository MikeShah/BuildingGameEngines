// Third-party libraries
import bindbc.sdl;

struct Sprite{

  SDL_Texture* mTexture;
  SDL_FRect     mRectangle;
  int mFrame =0;
  int x =0;
  int y =0;
  int xDirection=1;
  int yDirection=1;

  this(SDL_Renderer* renderer, string bitmapFilePath){
    import std.string; // for toZString
                       // Create a texture
    SDL_Surface* mSurface = SDL_LoadBMP(bitmapFilePath.toStringz);
    mTexture = SDL_CreateTextureFromSurface(renderer,mSurface);
    SDL_DestroySurface(mSurface);
    // Position the rectangle 
    mRectangle.x = 50;
    mRectangle.y = 50;
    mRectangle.w = 100;
    mRectangle.h = 100;
  }

  // Destroy anything 'heap' allocated.
  // Remember, SDL is a C library, thus heap allocated resources need
  // to be destroyed
  ~this(){
    SDL_DestroyTexture(mTexture);
  }

  void Input(){}
  void Update(){

    if(xDirection==1){ ++x; }
    else if(xDirection==-1){ --x; }

    if(yDirection==1){ ++y; }
    else if(yDirection==-1){ --y; }

    if(mRectangle.x > 540){xDirection=-1;}
    if(mRectangle.x < 0){xDirection=1;}
    if(mRectangle.y > 380){yDirection=-1;}
    if(mRectangle.y < 0){yDirection=1;}

    mRectangle.x = 50+ x;
    mRectangle.y = 50+ y;
    mRectangle.w = 100;
    mRectangle.h = 100;

    mFrame++;
    // For this example, we want to 'cycle' through
    // these frames.
    if(mFrame > 3){
      mFrame =0;
    }
  }

  void Render(SDL_Renderer* renderer){
    // Selects a portion of the sprite sheet that we want
    // to draw from our renderer. We can think of this as 'copying'
    // data -- but really we are just selecting the 'texture coordinates'
    // within our GPU memory of what to draw.
    SDL_FRect selection;
    selection.x = 64*mFrame;
    selection.y = 0;
    selection.w = 64;
    selection.h = 64;

    // Copy a texture (or portion of a texture) to another
    // portion of video memory (i.e. a 2D grid of texels 
    // which span the width and height of the window)
    SDL_RenderTexture(renderer,mTexture,&selection,&mRectangle);
  }
}
