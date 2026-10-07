// Inspired by Quake 3 by creating an 'Event Journal'
// The idea is that a 'journal' is a record.
//
// 
import std.stdio, std.string;
import sdl_abstraction;
import bindbc.sdl;
import events, gameobject;

struct GameApplication{
  EventJournal mEventJournal;
  bool isGameRunning=true;
  SDL_Window* mWindow;
  SDL_Renderer* mRenderer;
  GameObject[] mGameObjects;

  this(string title){
    // Create na SDL Window
    mWindow = SDL_CreateWindow(title.toStringz,640,480, SDL_WINDOW_ALWAYS_ON_TOP);

    // Create a hardware accelerated mRenderer
    mRenderer = SDL_CreateRenderer(mWindow,null);
  }

  ~this(){
    // Destroy our renderer
    SDL_DestroyRenderer(mRenderer);
    // Destroy our window
    SDL_DestroyWindow(mWindow);
  }

  void SetupScene(){

    AddEvent(new Event_DebugLog("first message"));
    AddEvent(new Event_DebugLog("second message"));
    AddEvent(new Event_DebugLog("third message"));

    mGameObjects ~= new GameObject(mRenderer,"Mario");
  }

  // Add a new event
  void AddEvent(Event e){
    mEventJournal.PushEvent(e);
  }

  // Returns an event from the front of the event
  // queue and also pops it off the front of the queue.
  Event PeekAndPopEvent(){
    Event e = mEventJournal.PeekEvent();
    mEventJournal.PopEvent();
    return e;
  }

  void Update(){
    // Handle Gameplay events
    while(!mEventJournal.isQueueEmpty()){
      Event e = PeekAndPopEvent();
      // Handle event
      if(e !is null){
        e.Execute();
        writeln("Popped event");
        e.Serialize();

      }
    }
  }

  void Input(){
    // Store an SDL Event
    SDL_Event event;
    // Handle input from our polled event.
    // Event is stored in the structure."q
    while(SDL_PollEvent(&event)){
      if(event.type == SDL_EVENT_QUIT){
        isGameRunning = false;
        AddEvent(new Event_ExecuteScript(new Script_Exit())); 
      }
      if(event.type == SDL_EVENT_KEY_DOWN){
        writeln("Pressed a key ");
        AddEvent(new Event_DebugLog("new debug event")); 
      }
      if(event.type == SDL_EVENT_MOUSE_MOTION){
        AddEvent(new Event_Collision(mGameObjects[0],mGameObjects[0])); 
      }
    }

    const bool* keys = SDL_GetKeyboardState(null);
    if(keys[SDL_SCANCODE_W]){
        AddEvent(new Event_MoveGameObject(mGameObjects[0],0,-5));
    }
    if(keys[SDL_SCANCODE_S]){
        AddEvent(new Event_MoveGameObject(mGameObjects[0],0,5));
    }
    if(keys[SDL_SCANCODE_A]){
        AddEvent(new Event_MoveGameObject(mGameObjects[0],-5,0));
    }
    if(keys[SDL_SCANCODE_D]){
        AddEvent(new Event_MoveGameObject(mGameObjects[0],5,0));
    }
  }

  void Render(){
    // Set the render draw color 
    SDL_SetRenderDrawColor(mRenderer,100,190,255,SDL_ALPHA_OPAQUE);
    // Clear the renderer each time we render
    SDL_RenderClear(mRenderer);

    foreach(ref g; mGameObjects){
      g.Update(mRenderer);
    }

    // Final step is to present what we have copied into
    // video memory
    SDL_RenderPresent(mRenderer);
  }
  void AdvanceFrame(){
    Input();
    Update();
    Render(); 
  }

  void MainLoop(){
    SetupScene();

    while(isGameRunning){
      // Iterate through game objects
      AdvanceFrame();
      SDL_Delay(16);  // TODO: No frame capping
    }
  }
}
