import bindbc.sdl;
import appstate;

// Simple Sprite Class to hold a texture and a rectangle
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
