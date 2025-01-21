// @file malloc_example.d
import core.stdc.stdlib;

void main(){

    // Explicity allocate memory
    int* memory = cast(int*)(malloc(int.sizeof * 100));

    // We must now manually free memory like in C.
    free(memory);
}
