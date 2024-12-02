// @file: sse2.d
import std.stdio;
import core.simd;   // For SIMD instructions
import std.parallelism;

void main(){
    // SSE add
    float[4] a = [1.0f,1.0f,1.0f,1.0f];
    float[4] b = [1.0f,2.0f,3.0f,4.0f];
    float[4] result1 = 0.0f;; // Set all floats to 0.0f;

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

    // SSE Example 2
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
}
