// @file: cpu.d
// https://dlang.org/phobos/core_cpuid.html
// https://dlang.org/library/core/simd.html
// Good index of intrinsics: https://www.felixcloutier.com/x86/
import std.stdio;
import core.cpuid;
import core.simd;   // For SIMD instructions
import std.meta;

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
