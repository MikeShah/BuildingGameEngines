// @ uml.d
import std.stdio;
class GameObject{
	this(){
		writeln("constructing object");
	}
	~this(){
		writeln("Destroy, whenever garbage collector decides for class");
	}

	private:
			static int id;	// Shared amongst all classes
			int field1;     // Each 'instance' of an object, has a unique 
											// 'field1' variable
	public:
			void Battle(){}
			void Move(int x, int y){ /* ... */}
}

void main(){
	auto hero = new GameObject;  // 'hero' is an 'instance' of GameObject
	auto hero2 = new GameObject; // 'hero2' is a second 'instance'
	// Call member function (i.e. method). 
  // In 'D' we always use the dot operator, the compiler is smart 
  // enough to figure out if it should be a -> or . like in C / C++.
	hero.Battle();
	hero.Move(5,2);
}
