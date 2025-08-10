/// refcount.d
import std.stdio;
/// A simple reference counted structure.
/// The type is templated such that any type can be 
/// reference counted and deleted.

/// Reference counting requires us to do many 'heap allocations'
/// because any value (and the reference counter itself) needs
/// to be 'long lived' potentially past the scope in which the 
/// type was declared.
struct RefCount(T)
	// class types are not allowed as they are managed by the garbage
	// collector
	if(!is(T == class) && !is(T == interface))
{
	import core.stdc.stdlib;

	/// The underlying reference counted data structure
	T* mData;
	/// The reference count needs to be 'heap allocated' because
	/// ultimately we need the lifetime to be shared.
	size_t* mReferenceCount;
	/// Keep track of all of the references
	/// Note: This is only enabled in 'debug' mode.
	debug RefCount!T*[] mReferenceHistory;

	/// Construct the object, by default using the initial value.
	this(size_t length){
		debug{
			import std.stdio;
			writeln("Created: ",typeid(T)," length:",length);
		}

		// Allocate the object on the heap
			auto memory = cast(T*)malloc(T.sizeof * length);		
			// TODO: Error check
			// TODO: Consider if we should default initialize
			mData = memory;
			*mData = T.init;

		// Allocate storage for the reference count
		mReferenceCount = cast(size_t*)malloc(size_t.sizeof);	
		// Initial creation means reference count is always 1.
		*mReferenceCount = 1;
		debug mReferenceHistory ~= &this;
	}

	/// Copy construct the object
	/// 'Shallow copy' is okay here -- we're referencing the same
	/// object.
	this(ref RefCount!T copy){
		// 'share' the reference count so it is consistent.
		mReferenceCount = copy.mReferenceCount;
		// Shallow copy of same data
		mData = copy.mData;
		// Bump up the reference count
		++(*mReferenceCount);

		// DEBUG only mode
		debug mReferenceHistory ~= &copy;
	}	
	
	/// opAssign (operator assignment)
	void opAssign(ref RefCount!T lhs){
		// NOTE: You cannot simply assign, because we need
		//  		 to bump down the reference count of the
		//			 previous thing we were pointing to. So we 
		// 			 handle that case first.
		auto tmpValue = mData;
		auto tmpRefCount = mReferenceCount;

		mData = lhs.mData;
		mReferenceCount = lhs.mReferenceCount;
		++(*mReferenceCount);

		debug mReferenceHistory ~= &lhs;
		// Clean up the temporaries
		if(--(*tmpRefCount)==0){free(tmpRefCount); free(tmpValue);}
	}

	void opAssign(T value){
		*mData = value;
	}
	
	/// Destructor
	~this(){
		--(*mReferenceCount); // Bump down the reference count
		if(*mReferenceCount==0){
				debug{
						import std.stdio;
						writeln("Address:",&mData," Destroyed: ",typeid(T), " sizeof:",T.sizeof);
						writeln("\tReference history:",mReferenceHistory); 
				}
				free(mReferenceCount);
				free(mData);
		}
	}

	string toString() const pure @safe{
			import std.conv;
			return (*mData).to!string;
	}

}

// Stub for main function
void main(){

	// Static array type
	auto value5 = RefCount!(int[])(8);
	value5 = [1,2,3,4,5,6,7,8];
	
	// single value
	auto value = RefCount!int(1);
	value = 7;

	// Static array
	auto array = RefCount!int(10);

	auto someType = array;
	auto someType2 = array;

	{
		auto value1 = value;
	}

	writeln("value: ",value);
	writeln("array: ",array);
	writeln("value5: ",value5);
}
