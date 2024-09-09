// @file malloc_slice.d
import core.stdc.stdlib;
import std.stdio;

void main(){
    int* memory = cast(int*)(malloc(int.sizeof * 10));
    // Take advantage of D's slicing
    auto slice = cast(int[])memory[0 .. 10];
    // We can print out the memory
    foreach(index, element ; slice){
        writeln("[",index,"]\t",element);
    }
    // We must now manually free memory like in C.
    free(memory);
}
