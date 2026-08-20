// NOT COMPLETE YET
//
// dmd -betterC -unittest -main associativearray.d
// Nice way to build fast:
// ls associativearray.d | entr -c -s 'dmd -g -betterC -unittest -main associativearray.d && ./associativearray'
module associativearray;

extern(C):

import core.stdc.stdio;
import core.stdc.stdlib;
import std.traits;

/// TODO: Needed an example type for testing
struct ExampleType{
	size_t toHash() const{
		return 1;
	}
	bool opEquals(const typeof(this) rhs) const{
		return true; 
	}
}

/// Associtative Arrays are otherwise known as 'dictionaries'.
/// Associtive arrays are unordered, and store unique key/value pairs.
/// The 'Key' must be a type that has a 
struct AssociativeArray(Key,Value){
	size_t 	mSize;		// Number of 'keys' that have been added.
	size_t 	mCapacity;	// Capacity for the hashtable (i.e. the 'table size')
	bool	mOwns;		// Internally determine if we 'own' the memory.
				// Since in D associative arrays are 'reference types'
				// need to think about this when 'copies' are made.

	Value* mData;		// The values that we index into.
	bool*  mOccupied;	// Table of values telling us if a slot is occupied.

	invariant(){
		// TODO:
		assert(mCapacity != 0,"Invariant: AssociativeArray.mCapacity == 0, no capacity to add");
		assert(mSize <= mCapacity,"Invariant: AssociativeArray.size <= capacity");
	}

	// Disallow default constructor so that we have to specify
	// an initial size.
	//    @disable this();

	this(size_t initialCapacity){
		mSize       	= 0;
		mCapacity   	= initialCapacity;
		mData       	= cast(Value*)malloc(Value.sizeof*mCapacity);
		mOccupied	= cast(bool*)malloc(bool.sizeof*mCapacity);
		for(size_t i=0; i < mCapacity; i++){
			mOccupied[i] = false;
		}
		
		mOwns 		= true;
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
			free(mOccupied);
			mData = null;
		}
		mSize 	  = size_t.init;
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

		Value* 	newdata = cast(Value*)malloc(Value.sizeof*rhs.mCapacity);
		for(size_t i=0; i < rhs.mCapacity; i++){
			newdata[i] = rhs.mData[i];
		}
		bool* 	occupied= cast(bool*)malloc(bool.sizeof*rhs.mCapacity);
		for(size_t i=0; i < rhs.mCapacity; i++){
			occupied[i] = rhs.mOccupied[i];
		}
		mData 		= newdata;
		mSize 		= rhs.mSize;
		mCapacity 	= rhs.mCapacity;
		mOccupied	= occupied;
		mOwns 		= true;	
		printf("A copy was made\n");
	}
	
	/// Return the value given a key
	Value opIndex()(Key k){ 
		static if(isIntegral!Key){
			size_t pos = k % mCapacity;
		}else{
			size_t pos = k.toHash() % mCapacity;
		}
//		assert(pos < mCapacity, "accessing memory outside of capacity");
		// TODO:
		mOccupied[pos] = true;
		return mData[pos];
	}

	ref Value get(Key k){
		static if(isIntegral!Key){
			size_t pos = k % mCapacity;
		}else{
			size_t pos = k.toHash() % mCapacity;
		}
//		assert(pos < mCapacity, "accessing memory outside of capacity");
		// TODO:
		return mData[pos];
	}
	Value put(Key k, Value v){
		printf("called put\n");
		static if(isIntegral!Key){
			printf("integral type\n");
			printf("key is %d\n",k);
			printf("mCapacity is %d\n",mCapacity);
			size_t pos = k % mCapacity;
		}else{
			printf("non-integral type\n");
			size_t pos = k.toHash() % mCapacity;
		}
//		assert(pos < mCapacity, "accessing memory outside of capacity");
		// TODO:

		// Add the element
		printf("adding at pos %d\n",pos);
		mData[pos] = v;
		mOccupied[pos] = true;
		mSize++;
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

	/// Returns a pointer to the raw table data.
	/// The pointer cannot be changed otherwise
	const(Value*) data() const{
		return this.mData;
	}

	// ============ Iterator ========
	size_t nextKey=0;
	size_t totalKeysIterated=0;
	Value front(){
		++totalKeysIterated;
		return mData[nextKey];
	}
	void popFront(){
		printf("In popFront\n");
		// Move iterator to the 'nextKey' free slot in the table.
		for(size_t i=nextKey; nextKey < mCapacity; i++){
			printf("mOccupied[%d]\n",i);
			if(mOccupied[i]==false){
				nextKey++;
			}else{
				break;
			}
		}
		printf("nextKey is: %d\n",nextKey);
//		nextKey++;
	}
	bool empty() const{
		return totalKeysIterated==mSize;
	}
	// ==============================
}


unittest{
	printf("===start constructor test====\n");
	auto aa = AssociativeArray!(int,int)(16);
	printf("Make aa\n");


	aa.put(5,5);
	printf("added element\n");


	foreach(ref value; aa){
		printf("Printing value\n");
		printf("%d\n",value);
	}
	printf("===done constructor test====\n");
}

extern(C) void main()
{
	static foreach(u; __traits(getUnitTests, __traits(parent, main)))
		u();
}
