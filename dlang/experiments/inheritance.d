// Useful resources:
// https://www.youtube.com/watch?v=OtU51Ytfe04 C++Now 2018: Louis Dionne “Runtime Polymorphism: Back to the Basics”
//
// rdmd -betterC -vcg-ast inheritance.d
//
import std.stdio; // Not allowed in betterC
import std.algorithm;

import core.stdc.stdio;
extern(C):

mixin template Polymorphic(T){
    T* ptr; 		// pointer to data 'fields'
					// Perhaps need a 'map' or something?
    vTable!T table; // vTable to the type interface
}

// vTables statically created for each polymorphic type
// Pointers to member functions
struct vTable(T){
}

interface Animals(T){
    void speak();
}

struct Dog{
    int field;
    auto speak() => printf("Dog goes bark\n");
}

struct Cat{
    float field;
    auto speak() => printf("Cat goes meow\n");
}

// BetterC needs 'extern(C)'
extern(C) void main(){
    //auto animal = Polymorphic!Dog;
    Dog d;
    Cat c;
    // At run-time
    // https://forum.dlang.org/post/mnwivxvnumkkqrrtwali@forum.dlang.org
//    auto lst = [__traits(allMembers,Dog)];
//	writeln("lst:",lst);

//    auto lst2 = [__traits(allMembers,Dog)].filter!(a=> is(typeof("Dog."~a.stringof)==function));
//	writeln("lst2:",lst2);

	alias helper(alias T) = T;
//	writeln("Members:");
	foreach(m;__traits(allMembers,Dog)){
		alias member = helper!(__traits(getMember, Dog, m));
		if( is(typeof(member)==function)){
		//	pragma(msg,member);
//			writeln(m,":",typeof(member).stringof);
		}
	}
//	writeln();


//    static foreach(member ; [__traits(allMembers,Dog)]){
    //    mixin("string member = " ~ "Dog" ~ "."~member~";");
    //    static if( is(typeof(member) == function)){
    //    }
    //    writeln(member);
//    }
/*
    static foreach(i,m ; Dog.tupleof.stringof){
          //pragma(msg,stuff);
    }
    static foreach (i, m; Dog.tupleof) {
        writefln("%s:", i);

        enum name = Dog.tupleof[i].stringof[4..$];
        alias typeof(m) type;
        writefln("  S.tupleof[i]: %s", Dog.tupleof[i].stringof);
        writefln("  (type) name : (%s) %s", type.stringof, name);

 //       writefln("  m           : %s", m);
        writefln("  m.stringof  : %s", m.stringof);
    }
*/
    d.speak();
    c.speak();
}
