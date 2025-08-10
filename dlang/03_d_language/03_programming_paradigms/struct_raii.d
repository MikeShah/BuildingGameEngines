// @file struct_raii.d
import std.stdio;

struct GameObject{
	string mName;

	// If we provide a constructor
	this(string name){
		writeln("Constructor called");
		mName = name;
	}

	~this(){
		writeln("Called when destroyed: ",mName);
	}

	void MemberFunction(){
		writeln("Member Functions allowed in structs");
	}
}

void main(){
	// Create a struct on the stack
	GameObject obj = GameObject("mike");
	obj.MemberFunction();

	// Heap allocated struct
	{
		GameObject* obj_heap = new GameObject("mike_heap");
		obj_heap.MemberFunction();
		// Scope ended, but remember, garbage collector 'owns' memory
		// so it decides when things are deleted.
	}

	writeln("Program ended");
}
