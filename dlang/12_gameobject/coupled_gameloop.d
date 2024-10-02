// @file: coupled_gameloop.d
import core.atomic;
import std.stdio;
import std.conv;
alias GameEntity = GameObject;
alias GameActor = GameObject;

struct GameObject{
	// Constructor
	this(string name){
		assert(name.length > 0);
		mName = name;	
		// atomic increment of number of game objects
		sGameObjectCount.atomicOp!"+="(1);		
		mID = sGameObjectCount; 
	}

	void Update(){
		writeln(mName, "Update()");
	}

	// Destructor
	~this(){	}

	size_t GetID() const { return mID; }

	private:
	// Any private fields that make up the game object
	string mName;
	size_t mID;

	static shared size_t sGameObjectCount = 0;
}

struct GameApplication{

	this(int objects){
		for(size_t i=0; i < objects; i++){
			mGameObjects ~= GameObject("GameObject"~i.to!string);
		}
	}

	void Input() {}
	void Render() {}

	void Update() {
		foreach(ref obj ; mGameObjects){
			obj.Update();
		}
	}
	void AdvanceFrame(){
			Input();
			Update();
			Render();	
	}

	void Run(){
			while(mGamerunning){
				AdvanceFrame();
			}
	}
	
	GameObject[] mGameObjects;
	bool mGamerunning=true;
}

void main(){
	GameApplication app = GameApplication(5);
	app.Run();
}
