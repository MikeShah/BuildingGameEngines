// @file: functional_advantage.d
// Run with: rdmd functional_advantage.d
import std.stdio;
import std.random;

Mt19937 rnd; // Global -- for simplicity

shared static this(){
	// initialize a random number generator object one time.
	rnd = Random(unpredictableSeed);
}

struct Enemy{
	static int unique_id;
	int id;
	int strength;
	int magic;
	int health;
	// Note: For classes, you should 'override' the comparison operator (opEquals)
	int opCmp(ref const Enemy rhs){
		if((strength+magic) < (rhs.strength + rhs.magic)){
			return 1;
		}else if ((strength+magic) > (rhs.strength + rhs.magic)){
			return -1;
		}else{
			return 0;
		}
 	}
}

Enemy CreateRandomEnemyFactory(){
		Enemy temp;
		temp.id = Enemy.unique_id;
		Enemy.unique_id++;
		temp.strength = uniform(0,100,rnd);
		temp.magic= uniform(0,100,rnd);
		temp.health= uniform(0,100,rnd);
		return temp;
}


void main(){

	Enemy[] Enemies;
	// Create Enemies
	for(int i=0; i < 10; i++){
		Enemies ~= CreateRandomEnemyFactory();
	}

	// TASK: Target the top 5 enemies

	import std.algorithm;
	// First sort the enemies
	for(int i=0; i < Enemies.length; i++){
		for(int j=i; j < Enemies.length; j++){
			if(Enemies[i] > Enemies[j]){
				swap(Enemies[i],Enemies[j]);	
			}
		}	
	}
	//writeln("Procedural Sort:",Enemies);	
	// Grab top 5 ids
	int[] top5;
	for(int i=0; i< 5; i++){
		top5 ~= Enemies[i].id;
	}
	writeln(top5);

//	writeln(Enemies);
	writeln;

	import std.algorithm;
	import std.range;
	import std.array;
	// Demonstrate grabbing the '5' enemies
	// This is purely for debug purposes.
	writeln(Enemies.sort().take(5));
	// Grab just the '5' enemy ids to do something with them.
	writeln;
	auto ids = Enemies.sort().take(5).map!(a=> a.id).array;
	writeln("IDs, of our strongest 5:",ids);

}
