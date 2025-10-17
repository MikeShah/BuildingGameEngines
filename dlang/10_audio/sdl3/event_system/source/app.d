/// @ event_system/
import std.stdio, std.string, std.conv;
import sdl_abstraction;
import bindbc.sdl;

import sprite;
import event_system;
import app_state;


struct GameApplication{

	SDL_Renderer* mRenderer;
	SDL_Window* mWindow;
	bool mGameIsRunning=true;
	Sprite mySprite;
	AppState mAppState;

	// constructor
	this(string title){
		// Create a hardware accelerated window and renderer
		mWindow = SDL_CreateWindow(title.toStringz, 640,480, SDL_WINDOW_ALWAYS_ON_TOP);
		mRenderer = SDL_CreateRenderer(mWindow,null);
		mySprite = Sprite(mRenderer,"./assets/images/test.bmp");

	}
	~this(){
		// Destroy our mRenderer
		SDL_DestroyRenderer(mRenderer);
		// Destroy our mWindow
		SDL_DestroyWindow(mWindow);

	}

	void Input(){
		// Store an SDL Event
		SDL_Event event;
		while(SDL_PollEvent(&event)){
			if(event.type == SDL_EVENT_QUIT){
				writeln("Exit event triggered");
				mGameIsRunning= false;
			}

			if(event.type == SDL_EVENT_KEY_DOWN){
				Event msg;
				msg.type = EventEnum.MOVE_SPRITE;
				msg.move_sprite_event.mSpritePtr = &mySprite;
				msg.move_sprite_event.x = 1;
				msg.move_sprite_event.y = 1;

				mAppState.PushEvent(msg);

        // Slightly cleaner way of using struct
        Event msg = Event(type: EventEnum.MoveSprite, move_sprite_event.mSpritePtr: &mySprite, move_sprite_event.x : 1,						  			  move_sprite_event.y : 1);
			}
		}
	}

	/// With our event system, we now handle all game events
	/// in one place
	void Update(){
		// Update our sprite
		mySprite.Update();

		// Easier way to refer to the event queue
		ref Event[] eq = mAppState.mEventQueue;
		// Read an event off the Event Queue
		while(!eq.empty){
			// Get the first event
			Event e = mAppState.FrontEvent();
			// Pop it off the queue
			mAppState.PopEvent();
			// Handle the event
			HandleEvent(e);
		}
	}

	void Render(){
		// Set the render draw color 
		SDL_SetRenderDrawColor(mRenderer,100,190,255,SDL_ALPHA_OPAQUE);
		// Clear the mRenderer each time we render
		SDL_RenderClear(mRenderer);

		mySprite.Render(mRenderer);

		// Final step is to present what we have copied into
		// video memory
		SDL_RenderPresent(mRenderer);
	}

	void MainLoop(){
		// Example of a 'global' event queue.
		while(mGameIsRunning){
			Input();
			Update();
			Render();
		}
	}

}

// Program entry
void main()
{
	GameApplication app = GameApplication("Event System Example");
	app.MainLoop();
}
