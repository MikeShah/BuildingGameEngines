// @file struct_and_class.d
import std.stdio;

struct Struct{
	int data;
}


class Class{
	int data;
}

void main(){
	Struct s;
	Class c = new Class;

	s.data = 5;
	c.data = 4;
}


