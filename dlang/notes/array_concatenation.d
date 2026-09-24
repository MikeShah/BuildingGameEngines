// @file: array_concatenation.d
//
// This isn't an antipattern per-se, but it is something to watch out for.
// You see, when you 'share' mememory and do an allocation, one has to be
// careful if that 'concatenation' creates a 'realloc' call.
// Only one reference at the time is gaureenteed to otherwise point to the correct data.
import std.stdio;

void main(){

    auto arr = [1,2,3,4];
    auto sharing = arr; // Effectively both are 'pointing' to the same thing.
                        // That means the .ptr should be the same.

    writeln("&arr    :", &arr,    "     | address of pointer:",arr.ptr);
    writeln("&sharing:", &sharing,"     | address of pointer:",sharing.ptr);
    writeln(arr);
    writeln(sharing);

    writeln;

    // Force a reallocation of 'arr' by appending enough data to it.
    // This means that 'arr' will realloc, and the arr.ptr will update.
    // Now, the 'sharing.ptr' however is not updated.
    // To some degree, 'sharing'
    arr ~= [5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20];

    writeln("&arr    :", &arr,    "     | address of pointer:",arr.ptr);
    writeln("&sharing:", &sharing,"     | address of pointer:",sharing.ptr);
    writeln(arr);
    writeln(sharing);

}
