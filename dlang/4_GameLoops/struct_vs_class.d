// @file: struct_vs_class.d
 
// - Value Type
// - No inheritance
// - Default is 'stack' allocated, but can also be
//   allocatd with 'new'
// - No default constructor needed, but any constructors
//   defined need 1 or more arguments
// - Deterministic destruction when allocated on the stack
//   i.e. RAII (Resource Allocation is Initialization
struct MyStruct{
	int mField1;
	int mField2;

	this(int f1, int f2){
		mField1 = f1;
		mField1 = f2;
	}
	~this(){
	}
}

// - Reference Type
// - Must be allocated on heap with 'new'
// - Allows for Single inheritance
// - Can have inheritance from multiple interfaces
class MyClass{
	this(){}
	~this(){}

	int mField1;
	int mField2;
}

void main(){

}
