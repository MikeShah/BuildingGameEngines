// @file: inheritance.d
import core.atomic;
import std.stdio;

struct Texture{};
struct CollisionBox{};
struct Transform{};
struct State{};
struct Input{};
struct UserInterface2D{};
struct AIBehavior{};

class GameObject{
	this(){}
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
	Texture 			mTexture;
	CollisionBox 	mCollision;
	Transform 		mTransform;
	State 				mState;

	private:
	// Any private fields that make up the game object
	string mName;
	size_t mID;

	static shared size_t sGameObjectCount = 0;
}

class Mario : GameObject{
	protected:
	Input 					mInput;
	UserInterface2D	mUserInterface;
}

class AI : GameObject{
	protected:
	AIBehavior 			mAI;
}

void main(){
	// Stack allocated game object
	GameObject heapGameObject1= new GameObject("GameObject1");
	// Heap allocated game object
	GameObject heapGameObject2 = new GameObject("GameObject2");

	writeln(heapGameObject1.GetID());
	writeln(heapGameObject2.GetID());
}
