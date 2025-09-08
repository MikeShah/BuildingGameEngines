/// @file: sdl_dub_examples/06_sdl_sprite/app.d
import std.stdio;
import sdl_abstraction;
import bindbc.sdl;

struct Sprite{

    SDL_Texture* mTexture;
    SDL_Rect     mRectangle;

    this(SDL_Renderer* renderer, string bitmapFilePath){
        import std.string; // for toZString
                           // Create a texture
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
        SDL_RenderCopy(renderer,mTexture,null,&mRectangle);
    }
}

struct WaterSprite{
    Sprite s1;
    Sprite s2;
    
    bool xScroll = false;
    bool yScroll = false;


    this(SDL_Renderer* renderer, bool scrollOnX, bool scrollOnY,  string bitmapFilePath)
        in{
            assert(!(scrollOnY!=true && scrollOnX!=true), "Cannot scroll in both directions");
        }do
    {
        this.s1 = Sprite(renderer,bitmapFilePath);
        this.s2 = Sprite(renderer,bitmapFilePath);

        this.xScroll = scrollOnX;
        this.yScroll = scrollOnY;

        s1.mRectangle.x = 0;
        s1.mRectangle.y = 0;
        s1.mRectangle.w = 640;
        s1.mRectangle.h = 480;

        if(scrollOnY){
            s2.mRectangle.x = 0;
            s2.mRectangle.y = -480;
            s2.mRectangle.w = 640;
            s2.mRectangle.h = 480;
        }else if(scrollOnX){
            s2.mRectangle.x = -640;
            s2.mRectangle.y = 0;
            s2.mRectangle.w = 640;
            s2.mRectangle.h = 480;
        }
    }
    void Input(){}
    void Update(){
        if(yScroll){
            s1.mRectangle.y++;
            s2.mRectangle.y++;
            if(s1.mRectangle.y>=480){ s1.mRectangle.y = 0; }
            if(s2.mRectangle.y>=0){ s2.mRectangle.y = -480; }
        }
        if(xScroll){
            s1.mRectangle.x++;
            s2.mRectangle.x++;
            if(s1.mRectangle.x>=640){ s1.mRectangle.x = 0; }
            if(s2.mRectangle.x>=0){ s2.mRectangle.x = -640; }
        }


    }

    void Render(SDL_Renderer* renderer){
        // Set the texture blending mode
        SDL_SetTextureBlendMode(s1.mTexture, SDL_BLENDMODE_MOD);
        SDL_SetTextureBlendMode(s2.mTexture, SDL_BLENDMODE_MOD);
        // Copy a texture (or portion of a texture) to another
        // portion of video memory (i.e. a 2D grid of texels 
        // which span the width and height of the window)
        SDL_RenderCopy(renderer,s1.mTexture,null,&s1.mRectangle);
        SDL_RenderCopy(renderer,s2.mTexture,null,&s2.mRectangle);
    }
}

void main()
{
    SDL_Window* window = SDL_CreateWindow("Dlang SDL Window",
            0,0, 640,480, SDL_WINDOW_SHOWN);

    // Create a hardware accelerated mRenderer
    SDL_Renderer* renderer = SDL_CreateRenderer(window,-1,SDL_RENDERER_ACCELERATED);

    Sprite mySprite = Sprite(renderer,"./assets/images/test.bmp");
    auto mySprite2 = WaterSprite(renderer,true,false,"./assets/images/water.bmp");
    auto mySprite3 = WaterSprite(renderer,false,true,"./assets/images/water.bmp");

    bool gameIsRunning=true;
    while(gameIsRunning){
        // Store an SDL Event
        SDL_Event event;
        while(SDL_PollEvent(&event)){
            if(event.type == SDL_QUIT){
                writeln("Exit event triggered");
                gameIsRunning= false;
            }
            if(event.type == SDL_KEYDOWN){
                writeln("Pressed a key ");
            }
        }


        // Update our sprite
        mySprite.Update();
        mySprite2.Update();
        mySprite3.Update();

        // Slow down the application for the purpose of this demo
        SDL_Delay(16);  

        // Set the render draw color 
        SDL_SetRenderDrawColor(renderer,100,190,255,SDL_ALPHA_OPAQUE);
        // Clear the renderer each time we render
        SDL_RenderClear(renderer);

        mySprite2.Render(renderer);
        mySprite3.Render(renderer);
        mySprite.Render(renderer,  SDL_BLENDMODE_BLEND);

        // Final step is to present what we have copied into
        // video memory
        SDL_RenderPresent(renderer);
    }
    // Destroy our renderer
    SDL_DestroyRenderer(renderer);
    // Destroy our window
    SDL_DestroyWindow(window);
} // end main()
