// Note: This should be 'betterC' compatible, but you will need to remove
// 			 writeln, and malloc any memory.
import std.stdio;
import std.range;
import std.traits;

/// MyMap is a templated structure for a range (Specifically an InputRange)
/// Note: That the first parameter is an 'alias' template parameter.
///       https://dlang.org/spec/template.html#aliasparameters.
///			  This means that we can effectively use any symbol (function, delegate)
///       here (in fact, we can use lots of things, but we really need a function or delegate for our map).
///       Thus this is the most flexible way to implement a 'map' range struct.
/// Note: As an exercise going forward, you might consider to add additional
///       functions to make this bidirectional, or randomacess.
		struct MyMap(alias transform, T)
if(isInputRange!T)	// At a minimum, we need a 'range' for our 'map' function. 
{
		T range;	// The range we are 'mapping' over if instantiated.

		// constructor takes in the range and sets the range to the 
		// member.
		this(T range){
				this.range = range;
		}

		// Check if the range is infinite, and this
		// determines how our 'empty' function should be generated.
		static if(isInfinite!T){
				bool empty() { return false; }
		}else{
				bool empty() { return range.empty; }
		}

		// Forward other functions needed for InputRange interface
		void popFront() { range.popFront(); }
		@property auto front() { return transform(range.front); }
}


/// Helper function -- this is the interface to otherwise use our 'map' function.
auto mymap(alias transform, T)(T t){
		return MyMap!(transform, T)(t);
}

void main(){
		// Handy to ensure that our map satisfies the constraint.
		static assert(isInputRange!(MyMap!((a) => a, InputRange!int)));

		// Test case
		int[] collection = [1,2,3,4];
		foreach(elem ; mymap!((a)=>a*2)(collection)){
				writeln(elem);
		}
		// Note: The original collection is unchanged.
		// 			 You should otherwise return/store the values elsewhere if you
		//       want the modified values from the range.
		writeln("original collection is: ",collection);

		// Note: In this example, I provide all of arguments.
		mymap!((a)=>a*2,int[])([1,2,3,4]);
		// Note: Here, D is smart enough to 'infer' the type of int[].
		mymap!((a)=>a*2)([1,2,3,4]);

		// We can compare to the standard library version of std.map
		import std.algorithm;
		foreach(elem ; collection.map!(a=>a*2)){
				writeln(elem);
		}
		writeln(collection);


}
