// @file: serialize.d
import std.stdio;
import std.json;

struct Tree{
		TreeNode* mRoot;
}

struct TreeNode{
		TreeNode[] mChildren;
}
// Sample Game Object
struct GameObject{
		size_t mID;
		string mName;
}

// This is a trick to create a 'tuple' at compile-time.
template Tuple(T...){
		alias Tuple = T;
}
/// Returns the string with quotes around it.
string Quote(string str){
		return "\""~str~"\"";
}

// Takes in a game object, and serializes it into a json string
string Serialize(T)(T type){
		import std.conv;
		import std.typecons;
		import std.meta;

		string result;
		// https://dlang.org/spec/traits.html#allMembers
		// Create a compile-time sequence with all of the members
		alias fields  = Tuple!(__traits(allMembers, T));
		// Debug at compile time the fields
		/*
			 pragma(msg,"==========");
			 pragma(msg,fields);
			 pragma(msg,fields[0]);
			 pragma(msg,fields[1]);
			 pragma(msg,"==========");
		 */
		foreach(m ; fields){
				mixin("string value = type."~m~".to!string;");
				// Format and write out the string
				result ~= m.Quote()~":"~value.Quote() ~",";
		}

		return result;
}


// Takes in a string input and returns a type 
T Deserialize(T)(string input){
		T result;

		return result;
}


void main(){
		// String wysiwyg string
		string example=
				`
				{
						"gameobjects":[
						{"name":"gameObject1","id":0},
						{"name":"gameObject2","id":1},
						]	

				}
		`;
		//	writeln(example);

		//auto j = parseJSON(example);
		//writeln(j["gameobjects"]);

		GameObject g;
		g.mName = "mike";
		g.mID = 42;

		writeln("Game Object in-memory  :\n\t", g);
		writeln("Seralialized String    :\n\t",Serialize(g));

}

