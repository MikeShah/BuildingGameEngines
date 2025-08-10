// @file: struct_vs_class.d
 
/+
  - Basic Information
	- Value Type
	- No inheritance
	- Default is 'stack' allocated, but can also be
	  allocatd with 'new'
	- No default constructor needed, but any constructors
	  defined need 1 or more arguments
	- Deterministic destruction when allocated on the stack
	  i.e. RAII (Resource Allocation is Initialization
  - More Advanced Information
    - 
+/
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

/+
 - Basic Information
   - Reference Type
   - Must be allocated on heap with 'new'
   - Allows for Single inheritance
   - Can have inheritance from multiple interfaces
 - More Advanced Information
   - There is no deterministic destruction. While there is
     a destructor, we cannot know when the garbage collector will 
     reclaim the memory.
   - Every class inherits otherwise from 'Object'.
     This is sort of similar to Java, and you can find object.d.
	 Some D Developers will write their own 'object.d' to override the
     behavior -- this can be useful when targetting web platforms for example. 
   - The D Language Runtime is needed to support classes
     you can explore 'TypeInfo' for more information.
+/
class MyClass{
	this(){}
	~this(){}

	int mField1;
	int mField2;
}

void main(){

}
