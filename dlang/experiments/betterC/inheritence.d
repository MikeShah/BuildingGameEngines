// This example shows how to implement
// single inheritence without having to
// rely on the full d language, but only the 'betterC' subset
//

// rdmd -betterC inheritence.d
import core.stdc.stdio;

// The Actual type, and the 'vtable' otherwise of the type
struct IEntity{
    VTableGenericEntity* __vTable;
}

// The 'VTable' interface for an entity
struct VTableGenericEntity{
    string function(string) speak; 
    void   function(int,int) move; 
}

// Each polymorphic type
static VTableGenericEntity* generic;
static VTableGenericEntity* cat;
static VTableGenericEntity* dog;

extern(C) void main(){
    import core.stdc.stdlib;
    cat = cast(VTableGenericEntity*)malloc(VTableGenericEntity.sizeof);
    cat.speak = (string s) { printf("cat speak\n"); return "meow\n"; };
    cat.move  = (int x,int y) { printf("move meow\n");};

    dog = cast(VTableGenericEntity*)malloc(VTableGenericEntity.sizeof);
    dog.speak = (string s) { printf("dog speak\n"); return "rough\n"; };
    dog.move  = (int x,int y) { printf("move dog\n");};


    // Create an entity
    IEntity entity1 = {__vTable:generic};
    IEntity entity2 = {__vTable:cat};
    IEntity entity3 = {__vTable:dog};

    // Cat
    import std.stdio;
    writeln("entity2:",entity2);
    entity2.__vTable.speak("s");
    entity2.__vTable.move(0,0);

    // Dog
    entity3.__vTable.speak("d");
    entity3.__vTable.move(10,10);

	// entity3 is now a cat
	entity3.__vTable = cat;
	entity3.__vTable.speak("s");
    entity3.__vTable.move(10,10);

}
