// @file: sse4.d
import std.stdio;
import core.simd;   // For SIMD instructions

void main(){
    // SSE Example 4
    // Dot Product of Floating point values
    // Also called 'fused multiply and add (FMADD)' in some
    // libraries
    writeln;
    float4 v_a = [1.0f,1.0f,1.0f,1.0f];
    float4 v_b = [1.0f,2.0f,3.0f,4.0f];
    // Dot product for single-precision floating point
    // Note: Bit-mask at end uses high-4 bits telling us where to
    //       apply the dot product operation.
    float4 v_result = cast(float4) __simd(XMM.DPPS,v_a,v_b,0xFF); 
    writeln("v_a2: ",v_a);
    writeln("v_b2: ",v_b);

    // Sometimes we get duplicate results which is fine!
    writeln("v_r4: ",v_result);

    // Retrieve only one value if you like
    writeln("answer:",v_result[0]);
}
