/// @file class.d
import std.stdio;

class Student{
	/// constructor 
	/// In D we name the constructor 'this'
	this(string name, int id){
		mName = name;
		mID   = id;
	}

	string mName;
	int mID;
}

void main(){
//	Student mike = Student("mike",123); // error!
									    // needs  heap allocation
	auto mike = new Student("mike",123); // heap allocated
	writeln(mike);
	writeln(mike.mName);
	writeln(mike.mID);
}

