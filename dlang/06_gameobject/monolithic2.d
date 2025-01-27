// @file: monolithic2.d
import core.atomic;
import std.stdio;

struct Texture{};
struct CollisionBox{};
struct Transform{};
struct State{};
struct Input{};
struct UserInterface2D{};
struct AIBehavior{};

struct GameObject{
	// Constructor
	this(string name){
		assert(name.length > 0);
		mName = name;	
		// atomic increment of number of game objects
		sGameObjectCount.atomicOp!"+="(1);		
		mID = sGameObjectCount; 
	}

	// Destructor
	~this(){	}

	size_t GetID() const { return mID; }
	
	protected:
	// Common components for all game objects
	// Pointers are 'null' by default in DLang.
	// See reference types: https://dlang.org/spec/property.html#init
	Texture* 				mTexture;
	CollisionBox*		mCollision;
	Transform* 			mTransform;
	State* 					mState;
	Input* 					mInput;
	UserInterface2D* mUserInterface;
	AIBehavior* 		mAI;

	private:
	// Any private fields that make up the game object
	string mName;
	size_t mID;

	static shared size_t sGameObjectCount = 0;
}

void main(){
	GameObject* mario = new GameObject("Mario");
	mario.mTexture = new Texture();
}
