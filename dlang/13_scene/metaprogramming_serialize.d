// @file metaprogramming_serialize.d 
// Example showing how to automatically serialize a 
// struct with primitive types.
// If you have non-primitive types, then you can
// decompose to primitive types, or call a structs 
// 'serialize' function.
import std.stdio;
import std.json;

struct Attributes{
  int magic = 57;
  string info = "some data";
}

string Serialize(T)(T object){
  JSONValue jj = ["Type":T.stringof];
  static foreach(field ; T.tupleof){{
    mixin(`jj.object["`,field.stringof,`"]= object.`,field.stringof,`;`);
    // Note: When the loop unrolls, it is essentially generating
    //       these two lines automatically for every field provided.
    // jj.object["magic"]= object.magic;
    // jj.object["info"]= object.info;
  }} 
  return jj.toString;
}

void main(){
  Attributes example1 = Attributes(5,"some stuff");
  Attributes example2 = Attributes(7,"some different data");
  string serializedString = Serialize!Attributes(example1);
  serializedString.writeln;

  Serialize!Attributes(example2).writeln;
}



