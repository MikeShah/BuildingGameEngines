// @file: functional_map.d
import std.array;
import std.algorithm;
import std.stdio;

struct Enemy{
	int id; 
	int magic=50; // Default value, for illustration
}

void main(){

	Enemy[] Enemies;
	// Note: See differnce between 'reserve' and 'length' when you want
	//       to preallocate a dynamic array here:
	//       https://forum.dlang.org/post/qervmqlsfmjjyzyhmzkx@forum.dlang.org
	Enemies.length = 5;

	auto collectAllEnemies = Enemies.array;
	auto collectMagicOfAllEnemies = Enemies.map!(a=> a.magic).array;
	writeln("Enemies:",collectAllEnemies);
	writeln("Magic:  ",collectMagicOfAllEnemies);
}
