module sprite;
import sdl_abstraction;
import bindbc.sdl;
import std.string;

struct Sprite{

    SDL_Texture* mTexture;
    SDL_Rect     mRectangle;

    this(SDL_Renderer* renderer, string bitmapFilePath){
        SDL_Surface* mSurface = SDL_LoadBMP(bitmapFilePath.toStringz);
        mTexture = SDL_CreateTextureFromSurface(renderer,mSurface);
        SDL_FreeSurface(mSurface);
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
    void Update(){}

    void Render(SDL_Renderer* renderer){
        // Copy a texture (or portion of a texture) to another
        // portion of video memory (i.e. a 2D grid of texels 
        // which span the width and height of the window)
        SDL_RenderCopy(renderer,mTexture,null,&mRectangle);
    }
}
