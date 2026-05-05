// @file remove.d
// The following example shows you how to 'remove'
// elements from a dynamic array using the standard library.
import std.stdio, std.algorithm, std.conv;

class UDT{
  int data;
  this(int d){
    data = d;
  }
  override string toString(){
    return data.to!string;
  }
}


void main(){
  UDT[] items;

  for(int i=0; i < 10; i++){
    UDT elem = new UDT(i);
    items ~= elem;
  }

  // Show the original elements
  writeln(items);
  writeln(items.length);
  // Show what std.algorithm.remove does
  items.remove(4);
  writeln(items);
  writeln(items.length);
  // Show how to finally get rid of element
  items = items[0..$-1];
  writeln(items);
  writeln(items.length);

  // Let's remove a more arbitrary element
  items.countUntil(

}
