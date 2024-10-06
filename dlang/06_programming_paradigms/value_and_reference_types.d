// @file value_and_reference_types.d 
import std.stdio;

struct Struct{
	int data;
}

class Class{
	int data;
}

void SetValueTypeTest(Struct arg){
	arg.data = 9999;
}
void SetReferenceTypeTest(Class arg){
	arg.data = 9999;
}

void main(){
	Struct s;
	Class c = new Class;

	SetValueTypeTest(s);
	SetReferenceTypeTest(c);

	writeln(s.data);
	writeln(c.data);
}


