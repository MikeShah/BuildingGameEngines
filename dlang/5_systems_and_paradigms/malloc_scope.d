// @file malloc_scope.d
import core.stdc.stdlib;
import std.stdio;

void main(){
    int* memory = cast(int*)(malloc(int.sizeof * 10));
    // Scope guard
    // Ensures -- that 'free' is called 
    //            at the end of this scope
    // Nice, because the 'free' is near the declaration, 
    // as well as if we are in a funciton with lots of returns.
    //
    // See: https://tour.dlang.org/tour/en/gems/scope-guards
    scope(exit){
        free(memory);
    }

    // Take advantage of D's slicing
    auto slice = cast(int[])memory[0 .. 10];
    // We can print out the memory
    foreach(index, element ; slice){
        writeln("[",index,"]\t",element);
    }
}
