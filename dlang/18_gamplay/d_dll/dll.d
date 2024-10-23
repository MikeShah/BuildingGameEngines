// @file: ./d_dll/dll.d
// dmd -c dll.d -fPIC
// dmd dll.o -shared -of=libdll.so -defaultlib=libphobos2.so -L-rpath=.

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
