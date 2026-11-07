/// @file: /aabb/ 
import std.stdio, std.string, std.math, std.random;
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
Random rnd;

// Initialize globals
shared static this(){
  rnd = Random(unpredictableSeed);
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

struct Box{
  Point* p1 = new Point(10,10,1,1,2.0f);
  Point* p2 = new Point(10,40,1,1,2.0f);
  Point* p3 = new Point(40,10,1,1,2.0f);
  Point* p4 = new Point(40,40,1,1,2.0f);

  Stick s1,s2,s3,s4,s5;
  this(float x, float y, float w, float h){
    s1=Stick(p1,p2);
    s2=Stick(p2,p4);
    s3=Stick(p4,p3);
    s4=Stick(p3,p1);
  //  s5=Stick(p3,p4);
  }

  void Update(float deltaTime){
//    s1.Update(deltaTime);
//    s2.Update(deltaTime);
//    s3.Update(deltaTime);
//    s4.Update(deltaTime);
//    s5.Update(deltaTime);
  }

  void Render(SDL_Renderer* r){
    s1.Render(r);
    s2.Render(r);
    s3.Render(r);
    s4.Render(r);
//    s5.Render(r);
  }
}

// Note: For a stick you must do the allocation
struct Stick{
  Point* p1;
  Point* p2;
  float length;

  this(Point* p1_, Point* p2_){
    p1=p1_;
    p2=p2_;
    // Compute Length between two points automatically
    float dx = p1.x - p2.x;
    float dy = p1.y - p2.y;
    length = sqrt(dx*dx + dy*dy); 
  }
  void Update(float deltaTime){
    p1.Update(deltaTime);
    p2.Update(deltaTime);
    p1.Constrain();
    p2.Constrain();

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
    vx = x - prevX;
    vy = y - prevY;
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

  Point[] mPoints;

  Stick s1;

  Box b1;

  this(string title){
    // Create na SDL Window
    mWindow = SDL_CreateWindow(title.toStringz,
        640,480, SDL_WINDOW_ALWAYS_ON_TOP);

    // Create a hardware accelerated mRenderer
    mRenderer = SDL_CreateRenderer(mWindow,null);
  }


  void Setup(){
    // Populate a few points
    mPoints ~= Point(310,240,g.forceX,g.forceY,1.0f);
    mPoints ~= Point(330,240,g.forceX,g.forceY,1.0f);

    s1=Stick(
         new Point(310,250,g.forceX,g.forceY,2.0f),
         new Point(350,250,g.forceX,g.forceY,2.0f),
        );

    b1 = Box(0,0,20,20);
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
      if(event.type == SDL_EVENT_MOUSE_BUTTON_DOWN){
        float mouseX,mouseY;
        SDL_GetMouseState(&mouseX,&mouseY);
        writeln("Adding a new point");
        float vx = uniform(0,300,rnd)-150; 
        float vy = uniform(0,300,rnd)-150;
        float mass = uniform(1,10,rnd);
        mPoints ~= Point(mouseX,mouseY,vx,vy,mass);
      }
    }
  }


  void Update(){
    foreach(ref p ; mPoints){
      p.Update(g.deltaTime/1000);
      p.Constrain();
    }
    s1.Update(g.deltaTime/1000);
    b1.Update(g.deltaTime/1000);

  }

  void Render(){

    // Set the render draw color 
    SDL_SetRenderDrawColor(mRenderer,0,0,0,SDL_ALPHA_OPAQUE);
    // Clear the mRenderer each time we render
    SDL_RenderClear(mRenderer);

    foreach(ref p ; mPoints){
      p.Render(mRenderer);
    }

    s1.Render(mRenderer);
    b1.Render(mRenderer);

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
