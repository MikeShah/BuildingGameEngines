<<<<<<< HEAD
// @file: cpu.d
// https://dlang.org/phobos/core_cpuid.html
// https://dlang.org/library/core/simd.html
// Good index of intrinsics: https://www.felixcloutier.com/x86/
import std.stdio;
import core.cpuid;
import core.simd;   // For SIMD instructions

struct CPUInfo{
//    bool AES = aes();
}

// TODO:
// At compile-time generate a function that prints
// out a struct and its fields.
void PrintStruct(T)(){
    writeln("Has SSE: ",sse());    
}

void main(){
    PrintStruct!CPUInfo();
}
=======
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

>>>>>>> 6fcf9fb0c1622a72361dd9b27288f25bd1f34cff
