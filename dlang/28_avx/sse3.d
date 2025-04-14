// @file: sse3.d
import std.stdio;
import core.simd;   // For SIMD instructions

void main(){
    // SSE Example 3
    int4 v_a = [2,2,2,2];
    int4 v_b = [1,2,3,1];

    // Add operation
    int4 v_result1= cast(int4) __simd(XMM.PMADDWD,v_a, v_b); 
    
    // Do a horizontal add
    // (adds adjacent neighbors)
    // (Repeats results)
    int4 v_result2 = cast(int4) __simd(XMM.PHADDD,v_result1,v_result1);

    writeln("v_a: ",v_a);
    writeln("v_b: ",v_b);
    writeln("v_result1: ",v_result1);
    writeln("v_result2: ",v_result2);

}
