// https://dlang.org/phobos/core_cpuid.html
// https://dlang.org/library/core/simd.html
// Good index of intrinsics: https://www.felixcloutier.com/x86/
import std.stdio;
import core.cpuid;
import core.simd;   // For SIMD instructions
import std.parallelism;
import std.array;

struct CPUInfo{
//    bool AES = aes();
}

// At compile-time generate a function that prints
// out a struct and its fields.
void PrintStruct(T)(){
    
}


void main(){
    
    PrintStruct!CPUInfo();


    // Normal add
    float[4] a = [1.0f,1.0f,1.0f,1.0f];
    float[4] b = [1.0f,2.0f,3.0f,4.0f];
    float[4] result1 = 0.0f;; // Set all floats to 0.0f;

    // Ensure 'elem' is passed by ref so values mutate
    foreach(idx,ref elem; result1){
//        elem = a[idx] + b[idx];
    }

    // This also happens to be a data-parallel problem.
    // Meaning we can use a threadpool to otherwise perform
    // tasks independently and store the result at each
    // unique index.
    // 
    // Note: Why did I take a ' slice' of result?
    //       In D, a static array is not a range, but a slice is however.
    //       So in this way I can use .parallel on a range
    foreach(idx, ref elem; result1[0..$].parallel){
        result1[idx]= a[idx] + b[idx];
    }

    writeln(result1);

    // SIMD Example 1
    // New 'vectorized' type 'float4' for SIMD instruction
    float4 v_a = [1.0f,1.0f,1.0f,1.0f];
    float4 v_b = [1.0f,2.0f,3.0f,4.0f];
    float4 v_result1 = v_a + v_b; // Results in one instruction
    writeln(v_result1);


    // SIMD Example 2
    // Slow version
    int[100] data;
    foreach(i; 0 .. data.length){
        data[i] += 10; 
    }
    // Faster SIMD version
    // - 1/4th of the number of loop iterations.
    // - 1/4th the number of instructions. 
    int4[100 / int4.length] v_data; // We have '25 int4's' -- thus a total of 100 ints
    int4 tens = [10,10,10,10];      // Populate a SIMD register with 4, 10's
    foreach(i; 0 .. v_data.length){
        v_data[i] += tens;
    }
    writeln(v_data);

    // SIMD Example 3
    // Fused Multiply and add (i.e. dot product
    writeln;
    int4 v_a1 = [2,2,2,2];
    int4 v_b1 = [1,2,3,1];
    int4 v_result2 = cast(int4) __simd(XMM.PMADDWD,v_a1, v_b1); // Results in one instruction
    int4 v_result3 = cast(int4) __simd(XMM.PHADDD,v_result2,v_result2);
    writeln("v_a1: ",v_a1);
    writeln("v_b1: ",v_b1);
    writeln("v_r2: ",v_result2);
    writeln("v_r3: ",v_result3);


    // SIMD Example 4
    // Dot Product of Floating point values
    writeln;
    float4 v_a2 = [1.0f,1.0f,1.0f,1.0f];
    float4 v_b2 = [1.0f,2.0f,3.0f,4.0f];
    float4 v_result4 = cast(float4) __simd(XMM.DPPS,v_a2,v_b2,0xFF); // Masked-bits for which to store result.
    writeln("v_a2: ",v_a2);                                          // Sometimes we get duplicate results which is fine!
    writeln("v_b2: ",v_b2);
    writeln("v_r4: ",v_result4);

    // Things to keep in mind
    // 1. With SIMD you do need to test on every architecture you are running on.
    // 2. SIMD does need to be aligned
    //    Note: You likely need to put your vectorized types (i.e. SIMD types) at the top if you
    //          have them on structs to avoid paddig.
    //          e.g. https://www.youtube.com/watch?v=q_39RnxtkgM&t=133s
    //    Note: If you get additional padding, use it for something.
    //    Note: See the knapsack problem (can order by decreasing order of 'aligned size' as well.
    // 3. Generally we should not mix scalar and vector types
    //   Note: IF you need a float, then do that after your computation
    //   Note: There is the .array property of a vector type, but use that as a last resort when you're done
    //         with the computation.
    //   Note: Otherwise use: ttps://dlang.org/spec/simd.html#accessing_individual_elems
    // 4. Conditional Compilation useful to see what operations you can perform
    //    See: https://dlang.org/spec/simd.html#conditional_compilation
    // 5. Generally speaking, pass vector types by value in functions, no need to use registers.
    // 6. Use compound operations when possible (e.g. multiply and add veresus seperating to two different steps).

}
