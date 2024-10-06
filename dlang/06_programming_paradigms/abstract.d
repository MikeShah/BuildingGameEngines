// @file abstract.d

abstract class MyClass{
	int value;

	abstract void mustBeOverriden();

	// Can provide an implementation in MyClass
	void someFunction(){
		import std.stdio;
		writeln("default behavior");
	}

}

class Implementation : MyClass{

	// Must implement functionality from 'MyClass'
	override void mustBeOverriden(){
		import std.stdio;
		writeln("Implementation.mustBeOverriden()");
	}
}

void main(){
// 	auto type = new MyClass; // Error if you uncomment

		auto impl = new Implementation;
		impl.someFunction();
		impl.mustBeOverriden();

}
