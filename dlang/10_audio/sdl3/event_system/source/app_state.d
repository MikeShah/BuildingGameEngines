import std.stdio;
import event_system;

struct AppState{
	Event[] mEventQueue;

	// Get the front event
	Event FrontEvent(){
		if(mEventQueue.length>0){
			writeln("Top of Event Queue:",mEventQueue[0].type);
			return mEventQueue[0];
		}

		Event empty;
		empty.type = EventEnum.NOP;

		return empty;	// If size is empty, return a 'NOP' event
	}
	void PopEvent(){
		if(mEventQueue.length>0){
			mEventQueue = mEventQueue[1..$];
		}
	}
	// Append a new event.
	// Could do things like check validity of events and so on here as well.
	void PushEvent(Event e){
		mEventQueue~=e;
	}
}
