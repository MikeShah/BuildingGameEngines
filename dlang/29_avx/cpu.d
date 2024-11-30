// @file cpu.d
import core.cpuid;
import std.meta;
import std.stdio;

// Handy function to print out a struct and its fields only
void PrintStruct(T)(){
	alias fields = __traits(allMembers,T);
	alias types  = T.tupleof;
	
	static foreach(idx,field; fields){{
		writeln(typeof(types[idx]).stringof, ":", field);
	}}
}

void main(){

	PrintStruct!CacheInfo;

	CacheInfo c = CacheInfo(); 
	writeln(c.size);
	writeln(c.associativity);
	writeln(c.lineSize);
	
	writeln;

	writeln("avx: ",avx);
	writeln("avx2: ",avx2());
	writeln("stepping: ",stepping);
	writeln("model: ",model);
	writeln("family: ",family);
	writeln("cacheLevels: ",cacheLevels());
}

