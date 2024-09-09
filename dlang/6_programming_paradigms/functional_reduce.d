// @ file functional_reduce.d
import std.stdio;
import std.algorithm;   // reduce
import std.string;

void main(){

	// Loop style
	auto values1 = [7,5,8,2,4,1,3];
	typeof(values1[0]) minValue = values1[0]; // Assume we have one
											  // element? Or pick 
											  // int.max ?
	for(int i=0; i < values1.length; i++){
		if(values1[i] < minValue){
			minValue = values1[i];
		}	
	}
	writeln(minValue);

	// Functional-style
	auto values2 = [7,5,8,2,4,1,3];
	auto result = values2.reduce!min;
	writeln(result);
	// 'reduce' is like 'fold' in other langauges
}
