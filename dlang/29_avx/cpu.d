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
