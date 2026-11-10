/// @file: shaders/
import std.stdio;
import sdl_abstraction;
import bindbc.sdl;

struct Constants{
  float mouseX;
  float mouseY;
  float time;
  float color_scale;
}

SDL_GPUShader* LoadShader(SDL_Renderer* renderer, const char* filename){
  SDL_GPUDevice* gpu_device = SDL_GetGPURendererDevice(renderer);
  size_t shader_size=0;
  void* shader_code = SDL_LoadFile(filename,&shader_size);

  SDL_GPUShaderCreateInfo shader_info = SDL_GPUShaderCreateInfo(
      code_size: shader_size,
      code: cast(const ubyte*)shader_code,
      entrypoint: "main",
      format: SDL_GPU_SHADERFORMAT_SPIRV,
      num_samplers:1,
      num_uniform_buffers:1
      );

  SDL_GPUShader* result = SDL_CreateGPUShader(gpu_device, &shader_info);
  SDL_free(shader_code);

  return result;
}

// Main way to create a new pipeline, with a new fragment shader.
SDL_GPURenderState* CreateRenderState(SDL_Renderer* renderer, const char* filename){
  // Step 1: We need a shader
  SDL_GPUShader* gpuShader = LoadShader(renderer, filename);
  // We need some shader info
  SDL_GPURenderStateCreateInfo state_info;
  //SDL_zero(state_info);
  state_info.fragment_shader = gpuShader;

  return SDL_CreateGPURenderState(renderer, &state_info);
}

struct Sprite{

  SDL_Texture* mTexture;
  SDL_FRect     mRectangle;
  SDL_FRect     mSourceRectangle;


  this(SDL_Renderer* renderer, string bitmapFilePath, float x, float y, float w, float h){
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

  void Render(SDL_Renderer* renderer, SDL_BlendMode mode){
    // Set the texture blend mode
    SDL_SetTextureBlendMode(mTexture,mode);
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

void main()
{
  SDL_Window* window = SDL_CreateWindow("Dlang SDL Mike Shaders and Fake Lighting", 640,480, SDL_WINDOW_ALWAYS_ON_TOP);

  // Note: We need to use the 'GPU' Renderer
  SDL_Renderer* renderer 	= SDL_CreateGPURenderer(null,window); // Note to viewers: Try playing around with this!

  Sprite mySprite = Sprite(renderer,"./assets/images/background.bmp",0,0,640,480);
  Sprite fakeLight= Sprite(renderer,"./assets/images/light.bmp",0,0,128,128);

  // Create some renderer states
  SDL_GPURenderState* skyRenderState        = CreateRenderState(renderer,"./pipelines/sky.frag.spv");

  // Store mouse positions
  float mouseX,mouseY;
  // Counter(s)
  static float timer=0.0f;
  static float incrementer = 0.0f;
  static bool   grow = true;

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
    // Update mouse coordinates
    SDL_GetMouseState(&mouseX,&mouseY);
    // Update timer that is passed into shader
    timer+=1.0f;
    if(grow) {    incrementer += 0.005; }
    if(!grow){    incrementer -= 0.005f;}
    if(incrementer > 2.0) {grow=false;}
    if(incrementer < 0.05) {grow=true;}


    // Update our sprite
    mySprite.Update();
    fakeLight.Update();
    fakeLight.SetSourceRectangle(0,0,64,64);
    fakeLight.MoveSprite(mouseX-64,mouseY-64); // The '-64' is to center light around mouse

    Constants myConstants;

    myConstants.mouseX = mouseX;
    myConstants.mouseY = mouseY;
    myConstants.time   = timer;
    myConstants.color_scale = incrementer;


    // Set the render draw color 
    SDL_SetRenderDrawColor(renderer,100,190,255,SDL_ALPHA_OPAQUE);
    // Clear the renderer each time we render
    SDL_RenderClear(renderer);


    ///////////////////////////////// Sky RENDERING PATH /////////////////////////
    SDL_SetGPURenderState(renderer,skyRenderState);
    if(!SDL_SetGPURenderStateFragmentUniforms(skyRenderState,0,&myConstants,Constants.sizeof)){
      SDL_Log("Failed to push uniforms from CPU to GPU this frame: %s\n",SDL_GetError());
    }
    mySprite.Render(renderer, SDL_BLENDMODE_NONE);

    ///////////////////////////////// DEFAULT RENDERING PATH /////////////////////////
    // Setting render state to 'null' will use the default SDL settings.
    SDL_SetGPURenderState(renderer,null);
    fakeLight.Render(renderer, SDL_BLENDMODE_ADD);

    // Frame cap to 60 fps
    SDL_Delay(16);
    // Final step is to present what we have copied into
    // video memory
    SDL_RenderPresent(renderer);
  }
  // Destroy our renderer
  SDL_DestroyRenderer(renderer);
  // Destroy our window
  SDL_DestroyWindow(window);
} // end main()
