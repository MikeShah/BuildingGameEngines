// @file: inheritance.d
// This example demonstrates a way to avoid compile-time errors when
// using inheritance.
//
// The scenario is that when you have a collection of a base type
// (e.g. Sprites[]) then you might have a derived type (e.g. PlayerSprite)
// that is part of this collection.
//
// However -- when you call a member function that is only part of 
// PlayerSprite, then you will get a compile-time error.
// 
// My proposed solution is one of two things:
// - Either use 'opDispatch' to 'catch' the errant call, and then you
//   can effectively ignore the call. The type is not the right thing, 
//   so you can either ignore the call or log it and perform error handling.
// - The other option is to use a templated function that we forward
//   the arguments to. I then check against the type and then only
//   make the function call if the appropriate type is found.
//   A 'string mixin' is used to generate the code at compile-time.
import std.stdio, std.traits;

// 'key' is the type (stored in TypeInfo)
// The value is the name of the  member functions stored in a dynamic array
string[][TypeInfo] gMemberFunctions;

// Within module constructor, populate member functions of types
shared static this(){
 // Register 'Sprite' member functions
 foreach(member ; __traits(allMembers,Sprite)){
    gMemberFunctions[typeid(Sprite)] ~= member.stringof;
 }
 // Register 'PlayerSprite' member functions
 foreach(member ; __traits(allMembers,PlayerSprite)){
    gMemberFunctions[typeid(PlayerSprite)] ~= member.stringof;
 }
}

class Sprite{
  this(string name){}
  void Move(){  }
  Sprite opDispatch(string s)(int line = __LINE__){
    writeln("Sprite.opDispatch.",s, " at line: ",line);
    return this;
  }
}

class PlayerSprite : Sprite{
  this(string name){    super(name);  }
  void Respawn(){    writeln("PlayerSprite Respawn was called");  }
}

// TODO: Does not forward all of the args,
//       you simply build a string of arguments to forward into
//       the appropriate mixin.
Sprite TryCall(string fun, Args...)(ref Sprite s, Args args){
  write("TryCall!",fun,"--");
  if(typeid(s) is typeid(PlayerSprite)){
    mixin("(cast(PlayerSprite)s).",fun,"();");
    return s;
  }
  writeln("failed or not available with type...");
  return null;
}

void main(){
  Sprite[] sprites;
  sprites ~= new Sprite("Ethan");
  sprites ~= new PlayerSprite("PlayerSprite");

  writeln("====== typeid is 'runtime type information(TypeInfo)' ====");
  typeid(sprites[0]).writeln;
  typeid(sprites[1]).writeln;
  writeln;

  writeln("=== Respawn is not part of sprite[0], so call is delegated to special member function opDispatch ===");
  sprites[0].Respawn();
  writeln;

  writeln("==== TryCall is a templated function that will make the correct call based on the type ====");
  TryCall!("Respawn")(sprites[0]);
  TryCall!("Respawn")(sprites[1]);
  writeln;

  writeln("=== You could add more power by otherwise registering member function names and doing checks of valid function names === ");
 writeln("Key/Value of registered member functions per type:\n",gMemberFunctions);
  writeln;
  writeln;
}
