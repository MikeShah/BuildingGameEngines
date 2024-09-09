// @file stack_risk.d
import std.stdio;

int[] ThisIsOkay() {
    // 'auto' determines this as
    // a dynamically allocated array.
    // Thus, heap allocated
    auto nums = [0, 1, 2];
    writeln(typeid(nums));

    return nums;
}
/*
int[] ThisIsNotOkay() {
    // Stack allocated, fixed-size array
    // Why--nums goes out of scope when
    // this function exits, because it is
    // stack allocated -- this is not allowed
    // in the D programming language
    int[3] nums = [0,1,2];

    return nums;
}
*/
void main(){
    ThisIsOkay();
}

