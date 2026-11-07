/// @file: verlet
//
// A somewhat 'brittle' implementation of a verlet physics system that
// focuses on numerically stable computations of points.
// It's 'brittle' in the sense of using pointers and preallocating
// '100' points and then using the addresses from the original array.
// If you 'allocate' more than 100 points, the reallocation will use
// different addresses and break -- so you can either use a reference type
// (e.g. make 'points a class') or otherwise simply reference the 'index'
// from the global variables. A better implementation would use 'handles'
// so you can hide the implementation details.
import std.stdio, std.string, std.math, std.random;
import sdl_abstraction;
import bindbc.sdl;

struct PhysicsGlobals{
  float deltaTime;
  ulong lastFrame;
  float forceX;
  float forceY;

  Point[] points; // Global list of 'points' that are added

  this(float fx,float fy){
    forceX = fx;
    forceY = fy;
    deltaTime=1.0f;
    lastFrame  = SDL_GetTicks();

    // preallocate '100' points
    points= new Point[100];
  }

  void Update(float deltaTime){
    foreach(ref p; points){
      p.Update(deltaTime);
      p.Constrain();
    }
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
  Point* p1;
  Point* p2;
  Point* p3;
  Point* p4;

  Stick s1,s2,s3,s4,s5;
  this(Point* p1_, Point* p2_, Point* p3_, Point* p4_){
    p1=p1_;
    p2=p2_;
    p3=p3_;
    p4=p4_;

    s1=Stick(p1,p2);
    s2=Stick(p2,p4);
    s3=Stick(p4,p3);
    s4=Stick(p3,p1);
    s5=Stick(p1,p4);
  }

  void Update(float deltaTime){
    writeln("p1:",*p1);
    s1.Update(deltaTime);
    s2.Update(deltaTime);
    s3.Update(deltaTime);
    s4.Update(deltaTime);
    s5.Update(deltaTime);
  }

  void Render(SDL_Renderer* r){
    s1.Render(r);
    s2.Render(r);
    s3.Render(r);
    s4.Render(r);
    s5.Render(r);
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
    float dx = p2.x - p1.x;
    float dy = p2.y - p1.y;
    float currentLength = sqrt(dx*dx+dy*dy);
    float diff = length - currentLength;
    float percent = (diff / currentLength) / 2;

    float offsetX = dx * percent;
    float offsetY = dy * percent;
    if(!p1.pinned){
      p1.x -= offsetX;
      p1.y -= offsetY;
    }
    if(!p2.pinned){
      p2.x += offsetX;
      p2.y += offsetY;
    }
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
  bool pinned = false;
  this(float x_, float y_, float vx_, float vy_, float mass_, bool pinned_){
    x=x_;
    y=y_;
    prevX=x;
    prevY=y;
    vx=vx_;
    vy=vy_;
    mass=mass_;
    pinned = pinned_;
  }

  void Update(float deltaTime){
    // Do nothing if point is 'static' or 'pinned'
    if(pinned){
      return;
    }

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

  Stick s1;
  Stick anchor;
  Box b1;
  Box b2;

  this(string title){
    // Create na SDL Window
    mWindow = SDL_CreateWindow(title.toStringz,
        640,480, SDL_WINDOW_ALWAYS_ON_TOP);

    // Create a hardware accelerated mRenderer
    mRenderer = SDL_CreateRenderer(mWindow,null);
  }


  void Setup(){
    // Populate a few points
    g.points[0] = Point(310,240,0,0,1.0f,false);
    g.points[1] = Point(330,240,0,0,1.0f,false);

    // Stick
    g.points[2] = Point(310,250,0,0,2.0f,false),
    g.points[3] = Point(350,250,0,0,2.0f,false),
    s1=Stick(&g.points[2],&g.points[3]);

    // Box 1
    g.points[4] = Point(100,200,0,0,20.0f,false);
    g.points[5] = Point(100,240,0,0,20.0f,false);
    g.points[6] = Point(140,200,0,0,20.0f,false);
    g.points[7] = Point(140,240,0,0,20.0f,false);
    // Anchor
    g.points[8] = Point(120,60,0,0,2.0f,true);
    b1 = Box(&g.points[4],&g.points[5],&g.points[6],&g.points[7]);
    // Create one more stick that uses a point from the box to create a chain
    anchor = Stick(&g.points[4],&g.points[8]);

    // Box 2
    g.points[9] = Point(200,100,0,0,10.0f,false);
    g.points[10] = Point(200,140,0,0,10.0f,false);
    g.points[11] = Point(240,100,0,0,10.0f,false);
    g.points[12] = Point(240,140,0,0,10.0f,false);
    b2 = Box(&g.points[9],&g.points[10],&g.points[11],&g.points[12]);
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
        g.points ~= Point(mouseX,mouseY,vx,vy,mass,false);
        g.forceX = -g.forceX;
        g.forceY = -g.forceY;
        writeln(g.forceX,",",g.forceY);
      }
    }
  }


  void Update(){
    g.Update(g.deltaTime/1000);
    s1.Update(g.deltaTime/1000);
    b1.Update(g.deltaTime/1000);
    b2.Update(g.deltaTime/1000);
    anchor.Update(g.deltaTime/1000);
  }

  void Render(){

    // Set the render draw color 
    SDL_SetRenderDrawColor(mRenderer,0,0,0,SDL_ALPHA_OPAQUE);
    // Clear the mRenderer each time we render
    SDL_RenderClear(mRenderer);

    foreach(ref p ; g.points){
      p.Render(mRenderer);
    }

    s1.Render(mRenderer);
    b1.Render(mRenderer);
    b2.Render(mRenderer);
    anchor.Render(mRenderer);

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
  Application app = Application("SDL3 Physics Demo - Mike (left-click creatse points and reverse forces)");
  app.MainLoop();
} // end main()
