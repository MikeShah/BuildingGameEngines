import gameobject;
import std.stdio;
import std.traits;

template Validate(T){

}

// TODO: Consider passing in or checking for a 'Base' class so that I can also serialize those fields.
// TODO: Template mixin to automatically serialize and deserialize code
template SerializeAll(T){
  override void Serialize(){
    alias fieldNames = FieldNameTuple!T;
    writeln("  ",T.stringof);
    static foreach(idx,field; Fields!T){
      writeln("\t",field.stringof," ",fieldNames[idx].stringof);
    }
  }
  override void DeSerialize(string input){
      writeln("TODO: DeSerialize",input);
  }
}

abstract class Event{
  int time; // Time event occurred
  int type;
  string payload;

  this(){}
  this(int t, string load){
    type = t;
    payload = load;
  }

  abstract void Execute(/+ TODO: Maybe the gamestate gets passed in too? +/);
  abstract void Serialize();
  abstract void DeSerialize(string);
}

class Event_Collision : Event{
  mixin SerializeAll!(typeof(this));
  
  this(GameObject g1, GameObject g2){
  }
  override void Execute(){
    writeln("Collision");
  }

}

class Event_MoveGameObject : Event{
  mixin SerializeAll!(typeof(this));
  
  GameObject g;
  float x,y;

  this(GameObject g_, float x_, float y_){
    g = g_;
    x = x_;
    y = y_;
  }

  override void Execute(){
    g.mRectangle.x += x;
    g.mRectangle.y += y;
  }
}

class Event_DebugLog : Event{
  mixin SerializeAll!(typeof(this));

  string mLog;
  this(string log){
    mLog = log;
  }

  override void Execute(){
    writeln(mLog);
  }
}

class Event_ExecuteScript : Event{
  mixin SerializeAll!(typeof(this));

  IComponentScript mScript;

  this(IComponentScript script){
    mScript = script;
  }

  
  override void Execute(){
    writeln("TODO: Calling mScript.Update()");
    //mScript.Update();
  }

}


/// Data structure that effectively is a single queue for all events.
struct EventJournal{
  Event[] mEventJournal;
  void*[int] mEventHandlers;

  void PushEvent(Event e){
    mEventJournal ~= e;
  }

  void PopEvent(){
    if(mEventJournal.length>0){
      mEventJournal = mEventJournal[1..$];
    }
  }

  Event PeekEvent(){
    if(mEventJournal.length>0){
      return mEventJournal[0];
    }
    return null;
  }

  bool isQueueEmpty(){
    return mEventJournal.length ==0;
  }
}
