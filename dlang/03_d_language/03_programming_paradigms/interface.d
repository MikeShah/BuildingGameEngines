// @file interface.d
import std.stdio;

interface Animal{
	void Walk();
	void Talk();
	void Eat();

	// Can have a function that all Animal's get access
	// to, but must be marked 'final'.
	final void Move(){
		writeln("All animals have this function");
	}	
	// int someAttribute; // No Fields allowed in interface
}

class Dog : Animal{
	override void Walk(){ writeln("Dog walk"); }
	override void Talk(){}
	override void Eat(){}
}

void main(){

	// NOT allowed to create instance of interface
//	Animal illegal = new Animal; 

	// 'Generic' animal instantiated as Dog
	Animal someAnimal = new Dog;
	someAnimal.Move();
	someAnimal.Walk();

	// Dog instantiated as Dog
	Dog dog = new Dog;
	dog.Move();
	dog.Walk();
}
