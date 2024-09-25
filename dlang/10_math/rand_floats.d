// @file: rand_floats.d
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
		float ZeroTo15 = uniform01(G.rng)*15.0f;
		writeln(ZeroTo15);
	}

}
