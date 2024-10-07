// @file: procedural.d
import std.stdio;

struct Enemy{
	int id;
	int magic;
	int health;
	int strength;
}

void CreateEnemy(Enemy* enemy, int _magic, int _health, int _strength){
	static int id=0;
	enemy.id = ++id;
	enemy.magic = _magic;
	enemy.health = _health;
	enemy.strength = _strength;
}
	
void RunGame(){
	/* input/update/render loop */
}

void main(){
	// Allocate struct on the heap
	Enemy* e1 = new Enemy;
	CreateEnemy(e1,50,75,90);
	writeln(*e1);
	
	RunGame();
}
