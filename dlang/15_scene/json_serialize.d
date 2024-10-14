// @file json_serialize.d
import std.stdio;
import std.json;

void main(){
		// create a json struct
		JSONValue jj = [ "language": "D" ];
		// rating doesnt exist yet, so use .object to assign
		jj.object["rating"] = JSONValue(3.5);
		// create an array to assign to list
		jj.object["list"] = JSONValue( ["a", "b", "c"] );
		// list already exists, so .object optional
		jj["list"].array ~= JSONValue("D");

//		string jjStr = `{"language":"D","list":["a","b","c","D"],"rating":3.5}`;
		writeln(jj.toString); // jjStr 
}



