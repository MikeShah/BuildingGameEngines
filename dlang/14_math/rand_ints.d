// @file: rand_ints.d
import std.stdio;
import std.random;

// 'G' is short for globlas
struct G{
	static Random rng;
}

shared static this(){
	G.rng = Random(42);
}



void main(){
	for(int i=0; i < 5; ++i){
		writeln(uniform(0,15,G.rng));
	}

}
