// @file dlang_basics/memory.d
import std.stdio;

void main(){

    int[] DynamicallyAllocatedArray = new int[10];
    foreach(i ; DynamicallyAllocatedArray){
        writeln(i);
    }
}



