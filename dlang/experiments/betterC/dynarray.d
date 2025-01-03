// dmd -unittest -main dynarray.d
module dynarray;

extern(C):

import core.stdc.stdio;
import core.stdc.stdlib;

void writeline(T...)(T args){
    auto args2 = DynArray!(string)(args.length);
    printf("****Length is: %lu*******\n",args.length);
    printf("args2.mSize=%lu\n",args2.mSize);
    printf("args2.mCapacity=%lu\n",args2.mCapacity);

    static foreach(a ; args){
        args2.push_back(a.stringof);
    }
    foreach (a ; args2){
        printf("something: %s\n",cast(const char*)a);
    }
}

struct DynArray(T){
    T* data;            // pointer(ptr) to data
    size_t mSize;       // 'size' or 'length'
    size_t mCapacity;   // Internal allocation size

    invariant(){
        assert(mSize <= mCapacity,"DynArray.size < capacity");
    }
    // Disallow default constructor so that we have to specify
    // an initial size.
    @disable this();

    this(size_t initialCapacity){
        mSize       = 0;
        mCapacity   = initialCapacity;
        data        = cast(T*)malloc(T.sizeof*mCapacity);
    }
    ~this(){
        if(null != data){
            free(data);
            data = null;
        }
        mSize = size_t.init;
        mCapacity = size_t.init;
    }
    // Copy constructor
    // Note: Without this, we get in trouble for things, like
    //       even the iterator will accidently free our memory!
    this(ref DynArray!T rhs){
        printf("Copy constructor invoked\n"); 
        // Avoid copy  
        if(&this == &rhs){
            return;
        }
        T* newdata = cast(T*)malloc(T.sizeof*rhs.mCapacity);
        for(size_t i=0; i < rhs.mCapacity; i++){
            newdata[i] = rhs.data[i];
        }
        data = newdata;
        mSize = rhs.mSize;
        mCapacity = rhs.mCapacity;
    }
    // TODO: Handle OpAssign
    void opAssign(T)(ref DynArray!T rhs)
    {
        printf("opAssign invoked\n"); 
        // Avoid copy  
        if(&this == &rhs){
            return;
        }
        // Free any previous memory
        if(data!=null){
            free(data);
        }

        T* newdata = cast(T*)malloc(T.sizeof*rhs.mCapacity);
        for(size_t i=0; i < rhs.mCapacity; i++){
            newdata[i] = rhs.data[i];
        }
        data = newdata;
        mSize = rhs.mSize;
        mCapacity = rhs.mCapacity;
    }
    

    DynArray!T opIndexAssign(){
        return this; 
    }

    //
    typeof(this)* opSlice(size_t start, size_t end){
        assert(end-start>0,"negative size slice not allowed");
        typeof(this)* slice = cast(typeof(this)*)malloc((void*).sizeof);
        slice.data = data+start;
        slice.mSize= end-start;
        slice.mCapacity = end-start;
        return slice;
    }
    
    T opIndex()(size_t idx){ return data[idx];}


    //TODO: Implement the append operator
    void push_back(T)(T elem){
        if(mSize==mCapacity){
            // allocate double the space
            T* newdata = cast(T*)malloc(T.sizeof*mCapacity*2);
            // copy over previous data
            for(int i=0; i < mCapacity; i++){ 
                newdata[i] = data[i];
            }
            // Free data after the coy
            free(data);
            // Update capacity
            mCapacity = mCapacity*2;
            data = newdata;
        }
        data[mSize] = elem;
        mSize++;
    }

    ref T at(size_t pos){
        return data[pos];
    }

	size_t length() const{
		return mSize;
	}

    // ============ Iterator ========
    int next=0;
    T front(){
        return data[next];
    }
    void popFront(){
        next++;
    }
    bool empty() const{
        return next==mSize;
    }
    // ==============================
}

unittest{
    DynArray!int test = DynArray!int(5);
//    DynArray!int test;
    printf("Capacity: %lu\n",test.mCapacity);
    printf("Size: %lu\n",test.mSize);
    test.push_back(5);
    test.push_back(6);
    test.push_back(7);
    test.push_back(8);
    test.push_back(9);
    test.push_back(10);
    test.push_back(11);

    test.at(0) = 7777;

    foreach(data ; test){
        printf("%d\n",data);
    }

    printf("Size: %lu\n",test.mSize);
    printf("Capacity: %lu\n",test.mCapacity);
}

unittest{
    DynArray!int test = DynArray!int(5);
    test.at(4) = 4;
    DynArray!int test2 = test;

    DynArray!int test3 = DynArray!int(7);
    test3= test;

    assert(test.at(4) == test2.at(4));
    assert(test.at(4) == test3.at(4));

    test3=test3;
    assert(test3.at(4) == test3.at(4));
}
// Test out slicing
unittest{
    import core.stdc.stdio;
    import std.stdio;
    DynArray!int test = DynArray!int(5);
    printf("Initial test: %p\n", test.data);

    printf("=======Setting up=======\n");
    test.push_back(50);
    test.push_back(60);
    test.push_back(70);
    test.push_back(80);
    test.push_back(90);
    printf("=======Setting done =======\n");
    printf("=======Printing out test =======\n");
    printf("%d\n",test[0]);
    printf("%d\n",test[1]);
    printf("%d\n",test[2]);
    printf("%d\n",test[3]);
    printf("%d\n",test[4]);
    printf("=======Done printing test =======\n\n");
    
    printf("=======Grabbing Slice=======\n");
    auto slice = test[2..4];
    printf("=======Done Grabbing Slice======\n\n");

    //writeln("slice type is: ",typeid(slice));

    for(int i=0; i < slice.length; i++){
        printf("value is: %d\n",slice.at(i));
    }
}

extern(C) void main()
{
    static foreach(u; __traits(getUnitTests, __traits(parent, main)))
        u();
}
