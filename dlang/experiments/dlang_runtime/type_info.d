// @file: type_info.d
// Type information is available from the D Runtime for
// objects, and potentially very useful for 'classes'
// https://dlang.org/library/object/type_info.html
//
// The purpose of this snippet is to discuss one idea
// that came up during office hours regarding how to 
// handle storing types in an associtiative array and
// and array.
//
// You can use 'TypeInfo' as a key, or otherwise you
// could also use a 'flatArray' of generic component
// types and then 'gather' all of the components based
// on the TypeInfo which can serve as a unique key.
import std.stdio;
import std.typecons;
import std.algorithm;

// Template mixins are a nice way to add 'blocks' of
// code to a function.
mixin template PrintTemplate(T){
  void WhatAmI(){
    writeln("I am: ",typeid(T));
  }
}

class IComponent{}
class TransformComponent: IComponent{
  mixin PrintTemplate!(typeof(this));
}
class CollisionComponent: IComponent{
  mixin PrintTemplate!(typeof(this));
}
class TextureComponent  : IComponent{
  mixin PrintTemplate!(typeof(this));
}

// For this game object, I set it up to have
// a 'component' map using TypeInfo as a key.
// The advantage here is that I can leverage the
// D language runtime to store components, including
// potentially new components that are loaded dynamically
// during run-time.
class GameObjectAssociativeArray{
  IComponent[TypeInfo] componentMap;

  // For purpose of this demo, just add a bunch of components
  this(){
    TransformComponent t = new TransformComponent;
    componentMap[typeid(t)] = t;
  }

  // Templated function to get a component.
  T GetComponent(T)(){
    // typeid here will lookup the type, and we'll use
    // that to return a component.
    if(typeid(T) in componentMap){
      T component = cast(T)componentMap[typeid(T)];
      return component;
    }
    return null;
  }
}

// This game object will leverage a dynamic array,
// and simply have some operations to 'gather'
// components.
class GameOjectArray{
  IComponent[] components;

  // For purpose of this demo, just add a bunch of components
  this(){
    components ~= new TextureComponent;
    components ~= new CollisionComponent;
    components ~= new CollisionComponent;
  }
  // Templated function to get first matching component.
  T GetComponent(T)(){
    foreach(ref c ; components){
      if(typeid(c) == typeid(T)){
        return cast(T)c;
      }
    }
    return null;
  }
  // Templated function to get first 'n' matching component.
  IComponent[] GetComponents(T)(size_t max){
    IComponent[] collection;
    foreach(ref c ; components){
      if(typeid(c) == typeid(T)){
        collection ~= c;
      }
      if(collection.length > max){ break; }
    }
    return collection;
  }
}

// Entry point to program
void main(){
  // Create an instance of our object with associative array
  GameObjectAssociativeArray g1 = new GameObjectAssociativeArray;
  // Retrieve transform
  auto transform = g1.GetComponent!TransformComponent;
  transform.WhatAmI();

  // Create an instance of our game object with an array
  GameOjectArray g2 = new GameOjectArray;
  auto component = g2.GetComponent!TextureComponent;
  component.WhatAmI();

  auto collision_components = g2.GetComponents!CollisionComponent(5);
  collision_components.each!( a=> (cast(CollisionComponent)a).WhatAmI()); 
}
