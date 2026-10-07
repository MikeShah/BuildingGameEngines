// @file: gameobject
import bindbc.sdl;

class IComponentScript{
}

class Script_Exit : IComponentScript{
  this(){
  }
  void Update(){
  }
}

class GameObject{
  int id;
  string name;
  SDL_Texture* mTexture;
  // Rectangle is where we will represent the shape.
  SDL_FRect mRectangle;

  this(SDL_Renderer* renderer, string name_){
    name = name_;
    // Load the bitmap surface
    SDL_Surface* myTestImage   = SDL_LoadBMP("./assets/images/test.bmp");
    // Create a texture from the surface
    mTexture = SDL_CreateTextureFromSurface(renderer,myTestImage);
    assert(mTexture !is null, "could not load texture for some reason");
    // Done with the bitmap surface pixels after we create the texture, we have
    // effectively updated memory to GPU texture.
    SDL_DestroySurface(myTestImage);

    mRectangle.x = 50;
    mRectangle.y = 50;
    mRectangle.w = 100;
    mRectangle.h = 100;
  }

  ~this(){
    // Free Video Memory
    SDL_DestroyTexture(mTexture);
  }

  void Update(SDL_Renderer* renderer){
    // Copy a texture(or portion of a texture) to another
    // portion of video memory (i.e. a 2D grid of texels 
    // which span the width and height of the window)
    SDL_RenderTexture(renderer,mTexture,null,&mRectangle);
  }
}
