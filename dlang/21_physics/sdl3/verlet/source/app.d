/// @file: /aabb/ 
import std.stdio, std.string, std.math;
import sdl_abstraction;
import bindbc.sdl;

struct PhysicsGlobals{
  float deltaTime;
  ulong lastFrame;
  float forceX;
  float forceY;
  this(float fx,float fy){
    forceX = fx;
    forceY = fy;
    deltaTime=1.0f;
    lastFrame  = SDL_GetTicks();
  }
}

PhysicsGlobals g;

// Initialize globals
shared static this(){
  g = PhysicsGlobals(10,20);

}

/// Make an SDL Rectangle
SDL_FRect MakeRectangle(float x, float y, float w, float h){
  SDL_FRect rectangle;
  rectangle.x = x;
  rectangle.y = y;
  rectangle.w = w;
  rectangle.h = h;
  return rectangle;
}

struct Stick{
  Point p1;
  Point p2;
  float length;
  this(Point p1_, Point p2_){
    p1=p1_;
    p2=p2_;
    float dx = p1.x - p2.x;
    float dy = p1.y - p2.y;
    length = sqrt(dx*dx + dy*dy); 
  }
  void Update(float deltaTime){
    p1.Update(deltaTime);
    p2.Update(deltaTime);

    float dx = p2.x - p1.x;
    float dy = p2.y - p1.y;
    float currentLength = sqrt(dx*dx+dy*dy);
    float diff = length - currentLength;
    float percent = (diff / currentLength) / 2;

    float offsetX = dx * percent;
    float offsetY = dy * percent;
    p1.x -= offsetX;
    p1.y -= offsetY;
    p2.x += offsetX;
    p2.y += offsetY;
    
    p1.Constrain();
    p2.Constrain();
  }

  void Render(SDL_Renderer* r){
    SDL_SetRenderDrawColor(r,255,0,0,SDL_ALPHA_OPAQUE);
    SDL_RenderLine(r,p1.x,p1.y,p2.x,p2.y);
    p1.Render(r);
    p2.Render(r);
  }
}

struct Point{
  float x,y,vx,vy,mass;
  float prevX,prevY;
  this(float x_, float y_, float vx_, float vy_, float mass_){
    x=x_;
    y=y_;
    prevX=x;
    prevY=y;
    vx=vx_;
    vy=vy_;
    mass=mass_;
  }

  void Update(float deltaTime){

    // Verlet Integration
    // Acceleration is the same
    float accX = g.forceX / mass;
    float accY = g.forceY / mass;

    // Velocity is difference of positions
    vx = x- prevX;
    vy = y- prevY;
    prevX = x;
    prevY = y;

    // Update position
    x = x + vx + accX*(deltaTime*deltaTime);
    y = y + vy + accY*(deltaTime*deltaTime);

    /* Euler Method
    // F=ma rewritten as a=F/m
    float accX = g.forceX / mass;
    float accY = g.forceY / mass;

    // Now update velocity
    vx += accX * deltaTime;
    vy += accY * deltaTime;
    // Estimate next position
    x += vx * deltaTime;
    y += vy * deltaTime;

    writeln("Point:",this);
    */
  }

  void Render(SDL_Renderer* r){
    SDL_SetRenderDrawColor(r,128,255,0,SDL_ALPHA_OPAQUE);
    SDL_RenderPoint(r,x,y);
    SDL_FRect box = SDL_FRect(x,y,4,4);
    SDL_RenderRect(r,&box);
  }

  void Constrain(){

    // Verlet Constraint
    // Compute velocity again
    vx = x- prevX;
    vy = y- prevY;

    if(x<0){
      x = 0;
      prevX = x + vx;
    }
    if(x>640){
      x = 640;
      prevX = x + vx;
    }
    if(y<0){
      y = 0;
      prevY = y + vy;
    }
    if(y>480){
      y = 480;
      prevY = y + vy;
    }
    /+
    // Euler Constraint
    if(x<0){
      x = 0;
      vx *= -1;
    }
    if(x>640){
      x = 640;
      vx *= -1;
    }
    if(y<0){
      y = 0;
      vy *= -1;
    }
    if(y>480){
      y = 480;
      vy *= -1;
    }
    +/
  }
}

struct Application{
  SDL_Window*   mWindow;
  SDL_Renderer* mRenderer;
  bool mGameIsRunning=true;

  SDL_FRect r1,r2;
  SDL_FRect result;

  Point p1;
  Point p2;

  Stick s1;

  this(string title){
    // Create na SDL Window
    mWindow = SDL_CreateWindow(title.toStringz,
        640,480, SDL_WINDOW_ALWAYS_ON_TOP);

    // Create a hardware accelerated mRenderer
    mRenderer = SDL_CreateRenderer(mWindow,null);
  }


  void Setup(){
    // Make two rectangles
    r1 = MakeRectangle(50,50,100,100);
    r2 = MakeRectangle(50,50,100,100);
    p1 = Point(310,240,g.forceX,g.forceY,1.0f);
    p2 = Point(330,240,g.forceX,g.forceY,1.0f);

    s1=Stick(
         Point(310,250,g.forceX,g.forceY,2.0f),
         Point(350,250,g.forceX,g.forceY,2.0f),
        );
  }

  void Input(){
    // Store an SDL Event
    SDL_Event event;
    // Handle input from our polled event.
    // Event is stored in the structure."q
    while(SDL_PollEvent(&event)){
      if(event.type == SDL_EVENT_QUIT){
        writeln("Exit event triggered");
        mGameIsRunning= false;
      }
      if(event.type == SDL_EVENT_KEY_DOWN){
        writeln("Pressed a key ");
      }
    }
  }


  void Update(){
    p1.Update(g.deltaTime/1000);
    p2.Update(g.deltaTime/1000);
    s1.Update(g.deltaTime/1000);

    p1.Constrain();
    p2.Constrain();
  }

  void Render(){
    // Store mouse positions
    float mouseX,mouseY;
    SDL_GetMouseState(&mouseX,&mouseY);
    r2.x = mouseX;
    r2.y = mouseY;


    // Set the render draw color 
    SDL_SetRenderDrawColor(mRenderer,100,190,255,SDL_ALPHA_OPAQUE);
    // Clear the mRenderer each time we render
    SDL_RenderClear(mRenderer);


    // Draw the rectangles
    if(SDL_GetRectIntersectionFloat(&r1,&r2,&result)){
      // Fill in rectangle
      SDL_SetRenderDrawColor(mRenderer,255,255,255,SDL_ALPHA_OPAQUE);
      SDL_RenderFillRect(mRenderer, &result);
      // Set color of rectangles otherwise
      SDL_SetRenderDrawColor(mRenderer,255,0,0,SDL_ALPHA_OPAQUE);
    }else{
      SDL_SetRenderDrawColor(mRenderer,0,255,0,SDL_ALPHA_OPAQUE);
    }
    SDL_RenderRect(mRenderer, &r1);
    SDL_RenderRect(mRenderer, &r2);

    p1.Render(mRenderer);
    p2.Render(mRenderer);

    s1.Render(mRenderer);

    // Final step is to present what we have copied into
    // video memory
    SDL_RenderPresent(mRenderer);
  }


  void AdvanceFrame(){
      ulong startOfFrame = SDL_GetTicks();
      Input();
      Update();
      Render();

      SDL_Delay(16);

      g.deltaTime = startOfFrame - g.lastFrame;
      writeln("Delta Time:" ,startOfFrame,"-",g.lastFrame,"=",g.deltaTime);
      g.lastFrame  = startOfFrame;
  }

  void MainLoop(){
    Setup();

    // Infinite loop for our application
    while(mGameIsRunning){
      AdvanceFrame();
    }
  }

  ~this(){
    // Destroy our mRenderer
    SDL_DestroyRenderer(mRenderer);
    // Destroy our window
    SDL_DestroyWindow(mWindow);
  }

}

void main(){
  Application app = Application("SDL3 Physics Demo - Mike");
  app.MainLoop();
} // end main()
