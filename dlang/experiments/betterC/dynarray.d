// dmd -betterC -unittest -main dynarray.d
// Nice way to build fast:
// ls dynarray.d | entr -c -s 'dmd -g -betterC -unittest -main dynarray.d && ./dynarray '
module dynarray;

extern(C):

import core.stdc.stdio;
import core.stdc.stdlib;





/// betterC compatible function for debugging a DynArray
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

/// DynArray is a dynamic array similar to the built-in array
/// in D (or similarily, std::vector in C++).
struct DynArray(T){ 
    T* mData;            // pointer(ptr) to data
    size_t mSize;       // 'size' or 'length'
    size_t mCapacity;   // Internal allocation size
		bool 	 mOwns;				// Internally determine if we 'own' the memory.
												// If DynArray is a 'slice', then it is not the
												// owner and should not free memory.

    invariant(){
        assert(mSize <= mCapacity,"DynArray.size < capacity");
    }
    // Disallow default constructor so that we have to specify
    // an initial size.
//    @disable this();

		/// Constructor with an initial capacity 
    this()(size_t initialCapacity){
        mSize       = 0;
        mCapacity   = initialCapacity;
        mData       = cast(T*)malloc(T.sizeof*mCapacity);
				mOwns 			= true;
    }

		/// Constructor with that we can initialize with any number of elements
		/// Note: We need at least '1' argument, such that I want to get rid of
		///       any default constructor.
	import core.stdc.stdarg;
    this(V...)(ref V values)
			if(V.length >0)
		{
        mSize       = 0;
        mCapacity   = values.length;
        mData        = cast(T*)malloc(T.sizeof*mCapacity);
				mOwns 			= true;
    }

		/// Destructor
		/// Frees allocated memory automatically
    ~this(){
				if(!mOwns){
					return;
				}
				printf("Destructor called\n");
				        

				if(mData !is null){
						printf("SHOULD NOT PRINT\n");
            free(mData);
            mData = null;
        }
        mSize = size_t.init;
        mCapacity = size_t.init;
    }

    // Copy constructor
    // Note: Without this, we get in trouble for things, like
    //       even the iterator will accidently free our memory!
    this(ref return scope inout typeof(this) rhs){
        printf("Copy constructor invoked\n"); 
        // Avoid copy  
        if(this == rhs){
            return;
        }
        T* newdata = cast(T*)malloc(T.sizeof*rhs.mCapacity);
        for(size_t i=0; i < rhs.mCapacity; i++){
            newdata[i] = rhs.mData[i];
        }
        mData 		= newdata;
        mSize 		= rhs.mSize;
        mCapacity = rhs.mCapacity;
				mOwns 		= true;	
    }
    // TODO: Handle OpAssign
    void opAssign(T)(const ref typeof(this) rhs)
    {
        printf("opAssign invoked\n"); 
        // Avoid copy  
        if(&this == &rhs){
						
            return;
        }
        // Free any previous memory
        if(mData !is null){
						printf("SHOULD NOT PRINT\n");
            free(mData);
						mData = null;
        }

        T* newdata = cast(T*)malloc(T.sizeof*rhs.mCapacity);
        for(size_t i=0; i < rhs.mCapacity; i++){
            newdata[i] = rhs.mData[i];
        }
        mData 		= newdata;
        mSize 		= rhs.mSize;
        mCapacity = rhs.mCapacity;
				mOwns 		= true;
    }
  
		/// Overload for appending another DynArray to the current one
		DynArray!T opBinary(string op)(DynArray!T rhs){
			static if(op=="~"){
				// Case(1)
				// If we don't own the memory, then we need to make a copy
				// of the slice.
				if(!mOwns){

				}
	
				// Case (2)
				// Check if there is capacity to copy elements over without allocation.
				if(rhs.length < (mCapacity - mSize)){
					for(size_t i=0; i < rhs.length; i++){
						// TODO: Think about if this should be a copy or just assignment
						mData[mSize+i] = rhs.mData[i];
					}
					// Update the size
					mSize += rhs.length;
					return this;
				}
				//
				// Case (3)
				size_t newSize = rhs.mSize + this.mSize;
        T* temp = cast(T*)malloc(T.sizeof*newSize);
				// Reassign memory one element at a time.
				for(size_t i =0; i < this.mSize; i++){
					temp[i] = mData[i];
				}
				for(size_t i =mSize, j=0; i < newSize; i++, j++){
					temp[i] = rhs.mData[j];
				}
				// Update capacities and lengths, and reassign data
				free(mData);
				mData 		= null;
				mData 		= temp;
				mSize 		= newSize;
				mCapacity = newSize;
				mOwns 		= true;
				return this;		
			}
		}
		/// Overload for appending an individual element to DynArray!T
//		DynArray!T opBinary(string op)(T rhs){
//			static if(op=="~"){

//			}
//		}

		///
		/// Overload for prepending another DynArray to the current one
/*		DynArray!T opBinaryRight(string op)(DynArray!T lhs){
			static if(op=="~"){

			}
			assert(0);
		}
		/// Overload for prepending an individual element to DynArray!T
		DynArray!T opBinaryRight(string op)(T lhs){
			static if(op=="~"){

			}
			assert(0);
		}
*/

    // TODO
    DynArray!T opIndexAssign(){
//        return this; 
			assert(0, "Not yet implemented");
    }

    /// Slicing merely returns the same memory as a slice
    typeof(this) opSlice(size_t start, size_t end){
        assert(end-start>0,"negative size slice not allowed");
        typeof(this) slice;
        slice.mData 		= mData+start;
        slice.mSize			= end-start;
        slice.mCapacity = end-start;
				slice.mOwns 		= false;
        return slice;
    }
    
    /// Return the value at an index
    T opIndex()(size_t idx){ return mData[idx];}


    //TODO: Implement the append operator
    void push_back(T)(T elem){
				// Check if we need to expand
        if(mSize==mCapacity){
            // allocate double the space
            T* newdata = cast(T*)malloc(T.sizeof*mCapacity*2);
            // copy over previous data
            for(int i=0; i < mCapacity; i++){ 
                newdata[i] = mData[i];
            }
            // Free data after the coy
            free(mData);
            // Update capacity
            mCapacity = mCapacity*2;
            mData = newdata;
        }
        mData[mSize] = elem;
        mSize++;
    }

    ref T at(size_t pos){
				assert(pos < mCapacity, "accessing memory outside of capacity");
        return mData[pos];
    }

			size_t length() const{
				return mSize;
			}

		/// Returns true or false depending on if this DynArray is the owner
		/// of its memory. If the instance of DynArray is a 'slice', then it
		/// is not an owner of the memory.
		bool isOwner() const {
			return mOwns;
		}

    /// Returns a pointer to the raw data.
    /// The pointer cannot be changed otherwise
    const(T*) data() const{
        return this.mData;
    }

    // ============ Iterator ========
    int next=0;
    T front(){
        return mData[next];
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
		printf("=======test ======\n");
    DynArray!int test = DynArray!int(5);

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
		printf("=======test ======\n");
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
    printf("Initial test: %p\n", test.mData);

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
/// Testing append 1
unittest{
    import core.stdc.stdio;
    import std.stdio;
		printf("=======append test 1======\n");
    DynArray!int test1 = DynArray!int(5);
    DynArray!int test2 = DynArray!int(3);

		test2.push_back(1);
		test2.push_back(2);
		test2.push_back(3);

		test1 = test1 ~ test2;
		
    for(int i=0; i < test1.length; i++){
        printf("value is: %d\n",test1.at(i));
    }

		printf("===done append test 1 ====\n");
}
/// Testing append
unittest{
    import core.stdc.stdio;
    import std.stdio;
		printf("=======append test 2======\n");
    DynArray!int test1 = DynArray!int(2);
    DynArray!int test2 = DynArray!int(3);

		test1.push_back(4);

		test2.push_back(1);
		test2.push_back(2);
		test2.push_back(3);

		test1 = test1 ~ test2;
		// Do another append of 'test2' again
		test1 = test1 ~ test2;
		
    for(int i=0; i < test1.length; i++){
        printf("test1 : %d\n",test1.at(i));
    }

		printf("=======done append test 2======\n");
}

unittest{
	printf("=======slice ownership test======\n");
	auto memory = DynArray!int(5);
	memory.at(0) = 0;
	memory.at(1) = 1;
	memory.at(2) = 2;
	memory.at(3) = 3;
	memory.at(4) = 4;

	auto slice = memory[2..3];

	assert(memory.isOwner == true, "memory is the owner");
	assert(slice.isOwner == false, "slice is not the owner");

	slice = slice ~ memory;


	printf("=======done slice ownership test======\n");
}
unittest{
/*		printf("=======constructor test======\n");
    auto test1 = DynArray!(int)(2,3,4,5,6);

		test1.push_back(4);

    for(int i=0; i < test1.length; i++){
        printf("value is: %d\n",test1.at(i));
    }
*/
		printf("===done constructor test====\n");
}

extern(C) void main()
{
    static foreach(u; __traits(getUnitTests, __traits(parent, main)))
        u();
}
