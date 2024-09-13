// @file dll.d

// Compile with: 
// dmd -c dll.d -fPIC
// dmd -oflibdll.so dll.o -shared

import core.stdc.stdio;

extern (C) int dll()
{
    printf("dll()\n");
    return 0;
}

shared static this()
{
    printf("libdll.so shared static this\n");
}

shared static ~this()
{
    printf("libdll.so shared static ~this\n");
}
