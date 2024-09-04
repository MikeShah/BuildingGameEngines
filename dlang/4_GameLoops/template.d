// @file: template.d
import std.stdio;

// Generic Template Block
template GenericBlock(T){
	T someVariable;
	T anotherVariable;
} 
// Make it easier to access template code block
alias IntBlock = GenericBlock!(int);
alias FloatBlock = GenericBlock!(float);

// Simple example of template
auto Add(T)(T value1, T value2){
	return value1+value2;
}

// More powerful template
// Prints 'variable' number of arguments
auto PrintLines(T...)(T values){
	foreach(v ; values){
		writeln(v);
	}	
}
// Specialized template for a single 'array'
auto PrintLines(T)(T[] values){
	foreach(v ; values){
		writeln(v);
	}	
}
// Structs (and classes) can be templated
struct DataStructure(T){
	T[] data;
	int size;
}
// Interfaces
interface Interface(T){
	void MemberFunction();
}

void main(){
	// Use the template code blocks
	IntBlock.someVariable= 7;	
	FloatBlock.someVariable= 7.0f;	

	writeln(Add!(int)(1,2));
	writeln(Add(1.2f,2.3f)); // D can 'infer' template arguments in many cases

	PrintLines([1,2,3,4,5,6]);
	PrintLines([1,2,3,4,5,6],[1,2,3,4]);
}


