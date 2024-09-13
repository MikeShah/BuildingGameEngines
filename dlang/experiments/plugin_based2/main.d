// @ file main.d
//
// Compile with: 
// dmd -c main.o -L-ldl -L-rpath=. -map -of=main
// dmd main.o -L-ldl -L-rpath=. -map


import core.stdc.stdio;
import core.stdc.stdlib;
import core.sys.posix.dlfcn;

extern (C) int dll();

int main()
{
    printf("+main()\n");

    void* lh = dlopen("libdll.so", RTLD_LAZY);
    if (!lh)
    {
        fprintf(stderr, "dlopen error: %s\n", dlerror());
        exit(1);
    }
    printf("libdll.so is loaded\n");

    int function() fn = cast(int function())dlsym(lh, "dll");
    
    char* error = dlerror();
    if (error)
    {
        fprintf(stderr, "dlsym error: %s\n", error);
        exit(1);
    }
    printf("dll() function is found\n");

    fn();

    printf("unloading libdll.so\n");
    dlclose(lh);

    printf("-main()\n");
    return 0;
}

shared static this() { printf("main shared static this\n"); }

shared static ~this() { printf("main shared static ~this\n"); }
