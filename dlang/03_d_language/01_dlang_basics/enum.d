// @file enum.d
import std.stdio;

enum value = 1;

enum MyArrayOfRandomNumbers = [5,8,3,1,9,3];
// For large arrays that will be reused, I instead suggest
// allocating the memory and referring to the same symbol.
// e.g. 
//static immutable MyArrayOfRandomNumbers = [5,8,3,1,9,3];


void main(){

  pragma(msg,"'value' at compile-time: ",value);
  writeln("Enum value at run-time : ", value);

  // Keep in mind each usage of 'MyArray of RandomNumbers'
  // is going to be duplicated.
  auto AnotherArray = MyArrayOfRandomNumbers;
  writeln(MyArrayOfRandomNumbers);


}
