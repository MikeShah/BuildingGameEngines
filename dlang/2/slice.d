// @file slice.d

// Example shows working with dynamic arrays and slices
import std.stdio;

void main(){

    int[] array = [1,2,3,4];
    int[] slice = array[0 .. 4];
    // Modifies the same array
    // slices is essentially a pointer to th same array
    slice[0] = 50;

    writeln(array);
    writeln(slice);

    // Next experiment
    writeln();

    int[] cpy = array[0 .. 4].dup;
    cpy[0] = 7;
    writeln(array);
    writeln(cpy);
}
