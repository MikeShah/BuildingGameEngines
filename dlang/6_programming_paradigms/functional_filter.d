// @ file functional_filter.d
import std.stdio;
import std.algorithm;   // map
import std.string;

void main(){

	// Loop style
	// A little better with foreach loop
	auto words = ["hello", "world", "dlang", "c++", "java"];
	int coolLangauges = 0;
	foreach(element ; words){
		if(element=="dlang"){
			coolLangauges++;
		}
	}
	writeln("Cool langauges found: ",coolLangauges);

	// Functional-style

	import std.array;
	auto result = words.filter!(a=> a.indexOf("dlang") >=0).array;
	writeln("Cool langauges found: ",result);

	writeln("cool languages found: ",["hello", "world", "dlang", "c++", "java"].filter!(a=> a.indexOf("dlang") >=0).array);

}
