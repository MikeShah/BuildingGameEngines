// @ file functional_increment.d
import std.stdio;
import std.algorithm;   // map
import std.range; 		// iota

void main(){

	// Loop style
	int[] numbers = [1,2,3];
	for(int i=0; i < numbers.length; i++){
		numbers[i]=numbers[i]+1;
	}
	writeln(numbers);

	// Functional-style
	auto range = iota(1,4,1);
	auto result = range.map!(a=>a+1);
	writeln(result);

	iota(1,4,1).map!"a=>a+1".writeln;

}




