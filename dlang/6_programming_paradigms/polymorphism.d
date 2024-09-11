// @file: polymorphism.d
import std.stdio;
interface IGameEntity{
	void Update();
}

class GameEntity : IGameEntity{
	this(string name){	mName = name; }
	override void Update(){ writeln("GameEntity.Update()");}
	string mName;
}
class EnemyEntity : GameEntity{
	this(string name){	super(name); }
	override void Update(){ writeln("EnemyEntity.Update()");}
	string mName;
}

void main(){
	IGameEntity entity1 = new GameEntity("Some Game Entity1");
	IGameEntity enemyEntity= new EnemyEntity("Enemy Entity");

	IGameEntity[] collection;
	collection ~= entity1;
	collection ~= enemyEntity;

	writeln(collection);
	collection[0].Update();
	collection[1].Update();
// Not allowed to instantiate interface
// 	EnemyEntity enemy = new IGameEntity;
	GameEntity test = new GameEntity("What type am test2?");
	GameEntity test2 = new EnemyEntity("What type am test2?");
	test.Update();	 	
	test2.Update();	 	
}
