// @file: sse1.d
import std.stdio;
import core.simd;   // For SIMD instructions

void main(){
    // Normal add
    float[4] a = [1.0f,1.0f,1.0f,1.0f];
    float[4] b = [1.0f,2.0f,3.0f,4.0f];
    float[4] result1 = 0.0f;; // Set all floats to 0.0f;

    // Ensure 'elem' is passed by ref so values mutate
    foreach(idx,ref elem; result1){
        elem = a[idx] + b[idx];
    }
    writeln("result1  :",result1);

    // SSE add
    // New 'vectorized' type 'float4' for SIMD instruction
    float4 v_a = [1.0f,1.0f,1.0f,1.0f];
    float4 v_b = [1.0f,2.0f,3.0f,4.0f];
    float4 v_result1 = v_a + v_b; // Results in one instruction
    writeln("v_result1:",v_result1);

}
