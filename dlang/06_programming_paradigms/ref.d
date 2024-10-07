// @file ref.d 
import std.stdio;

struct Struct{
	int data;
}

void SetValueTypeTest(Struct* arg){
	arg.data = 9999;
}

void SetValueTypeTestRef(ref Struct arg){
	arg.data = 9999;
}

void main(){
	Struct* s1 = new Struct;
	Struct s2;

	SetValueTypeTest(s1);
	SetValueTypeTestRef(s2);

	writeln(s1.data);
	writeln(s2.data);
}


