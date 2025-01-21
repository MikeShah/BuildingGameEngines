import std;


static foreach(op .. ['+','-']){
	string result;
	result ~= ("case "~op~":");
	result ~= ("result = op1 " ~ op ~ "op2;");
	("break;")
	mixin(result);
}





struct SafeArray{
	
	invariant(){

	}

	int[] mData;
}


@safe func(){
	writeln("hello");
	auto test = [1,2,3,4,5,6];
	// int[]

	test.length = 20;

	auto slice = test[1 .. 11 ];
	

}

void main(){


	func();
}
