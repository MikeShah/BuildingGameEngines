// Starting an experiment with a smart pointer
//
// rdmd -unittest -betterC smartpointer.d
import core.stdc.stdio;
import core.stdc.stdlib;

extern(C):

// Incomplete 'print' for doing work with betterC and flipping
// between D language for quick debugging.
void print(T...)(T values){
    version(D_BetterC){
        import core.stdc.stdio;
        alias a = values[0];
        printf("%s\n",cast(const char*)a);
    }else{
        import std.stdio;
        writeln(values);
    }
}

// Factory for creating shared pointers
SharedPtr!T makeSharedPtr(T)(){
    print("Factory used to make smart pointer");
    SharedPtr!T result;
    result.ptr = cast(T*)malloc(T.sizeof);
    result.refCount=1;
    
    return result;
}

// TODO: Need to use atomics for bumping up refCount to ensure
//       no issue with race conditions.
struct SharedPtr(T){
    T* ptr;
    size_t refCount=0;

    // Construct
    this(T value){
        print("constructor called and value initialized");
        ptr = cast(T*)malloc(T.sizeof);
        *ptr = value;
        if(ptr==null){
        }
        //printf("created: %d\n",*ptr);
    }

    ~this(){
        print("freed");
        refCount--;    
        if(refCount==0){
            if(ptr!=null){
                free(ptr);
                ptr=null;
            }
        }
    }
    
    // Note allowed to assign to naked pointers with the smart pointer
    // class, so just fire off an assert immediately
    void opAssign(T)(T* rhs){
        static assert(0,"Error: Assigning to naked pointer--\n\t",__MODULE__,":",__FILE__,":",__LINE__);
    }
    
    // Pass by reference to ensure that count is bumped up
    void opAssign(T)(ref SharedPtr!T rhs){
        print("assigned1");
        ptr = rhs.ptr;
        if(ptr==null){
        }else{
//            print("Assignment: %d\n",*ptr);
            rhs.refCount++;
        }
    }

    // Dereference the SharedPtr Pointer
    T opUnary(string s)()
        if(s=="*")
    {
        print("Dereferenced");
        return *ptr;
    }
}

void main(){
    int someValue = 42;
    static foreach(u; __traits(getUnitTests, __traits(parent, main)))
            u();

    auto value = new int;

    print("program end");
}

unittest{
    // Make the smart pointer
    // Assign it illegally to 'naked' pointer
    // auto intPointer = makeSharedPtr!int;
    // intPointer = &someValue;
    // printf("deference: %d\n",*intPointer);
}

unittest{
    // Create a smart pointer and assign to another
    // Reference count should 'bump' up for both
    // pointers then
    auto intPointer1 = SharedPtr!int(5);
    auto intPointer2 = intPointer1;

    auto intPointer4 = makeSharedPtr!int;

    {
        SharedPtr!int intPointer5;
        SharedPtr!int intPointer6;
        intPointer5 = intPointer4;
        intPointer6 = intPointer4;
    }
}


unittest{
    import dynarray;

//    auto dynamicArrayManaged1 = SharedPtr!(DynArray!int);
    auto dynamicArrayManaged2 = makeSharedPtr!(DynArray!int);
    SharedPtr!(DynArray!int) dynamicArrayManaged3;
    dynamicArrayManaged3 = dynamicArrayManaged2;
}
