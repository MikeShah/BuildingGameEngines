import bindbc.sdl;

struct Sprite{

    SDL_Texture* mTexture;
    SDL_FRect     mRectangle;

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


    void Move(int x, int y){
        mRectangle.x = x;
        mRectangle.y = y;
    }

    void Input(){}
    void Update(){}

    void Render(SDL_Renderer* renderer, SDL_BlendMode mode){
        // Set the texture blending mode
        SDL_SetTextureBlendMode(mTexture, mode);
        // Copy a texture (or portion of a texture) to another
        // portion of video memory (i.e. a 2D grid of texels 
        // which span the width and height of the window)
        SDL_RenderTexture(renderer,mTexture,null,&mRectangle);
    }
}
