// @file: interface2.d
import std.stdio;

// An interface, that enforces what we must implement.
// 'interfaces', I like to to prefix with "I".
interface IGameEntity{
	void Move();
	void Update();
	void Undo();
	// No member variables or fields allowed
}

// Only classes 'inherit' from interfaces.
class GameEntity : IGameEntity{
	this(string name){
		mName = name;
	}

	// Must implement these functions
	void Move(){}	
	void Update(){}
	void Undo(){}

	string mName;
}

void main(){
	// Game Entity can be allocated to anything that is a 'type of'
	// or otherwise in the 'inheritance tree'
	IGameEntity entity1 = new GameEntity("Some Game Entity1");
	entity1.Move();
	entity1.Undo();
}
