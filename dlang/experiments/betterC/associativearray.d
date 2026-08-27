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
	string toString(){
		return "TODO";
	}
}

/// Associtative Arrays are otherwise known as 'dictionaries'.
/// Associtive arrays are unordered, and store unique key/value pairs.
/// The 'Key' must be a type that has a 
///
/// Note: The 'KeyHashFunc' can be overriden to otherwise use 'toHash()' o
///	  or something else. For now, it uses a simple built-in hash
///	  function that is 'good enough' but not necessarily 'secure'
struct AssociativeArray(Key,Value,alias KeyHashFunc=null){
	size_t 	mSize;		// Number of 'keys' that have been added.
	size_t 	mCapacity;	// Capacity for the hashtable (i.e. the 'table size')
	bool	mOwns;		// Internally determine if we 'own' the memory.
	// TODO:
	//	Internally keep track of number of collisions.
	//	Need to consider if this is a 'debug' feature or can
	//   	be turned off.
	size_t mCollisionCount =0;


	// Helper function for hashing of keys that all keys can use
	size_t SimpleHash(Key k){
		size_t pos;
		static if(isIntegral!Key){
			pos = k % mCapacity;
		}else{
			ubyte[8] bytes;

			import std.digest.md;
			auto data = digest!MD5(k);

			size_t result=0;
			result |= data[0];

			pos = result % mCapacity;
		}
		return pos;
	}

	// Internal struct of key/value pairs
	struct KeyValue(Key, Value){
		Key key;
		Value value;
	}
	// Alias for the key value pair
	alias kv = KeyValue!(Key,Value);

	kv** mData;	// The values that we index into.

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
		mData       	= cast(kv**)malloc(kv.sizeof*mCapacity);
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
			for(int i=0; i < mCapacity; i++){
				if(mData[i] !is null){
					free(mData[i]);
				}
			}
			free(mData);
			mData = null;
		}
		mSize 	  = size_t.init;
		mCapacity = size_t.init;
	}

	// Copy constructor
	// Note: Without this, we get in trouble for things, like
	//       even the iterator will accidently free our memory!
	this(ref typeof(this) rhs){
		printf("Copy constructor invoked\n"); 
		// Avoid copy  
		if(this == rhs){
			return;
		}

		kv** 	newdata = cast(kv**)malloc(kv.sizeof*rhs.mCapacity);
		for(size_t i=0; i < rhs.mCapacity; i++){
			newdata[i] = rhs.mData[i];
		}
		mData 		= newdata;
		mSize 		= rhs.mSize;
		mCapacity 	= rhs.mCapacity;
		mOwns 		= true;	
	}
	
	/// Return the value given a key
	/// TODO: Need to check return type
	/// TODO: Consider just calling 'get' here.
	Value opIndex()(Key k){ 
		size_t pos = SimpleHash(k) % mCapacity;
//		assert(pos < mCapacity, "accessing memory outside of capacity");
		// TODO:
		return mData[pos];
	}

	ref kv* get(Key k){
		size_t pos = SimpleHash(k) % mCapacity;
//		assert(pos < mCapacity, "accessing memory outside of capacity");
		// TODO:
		return mData[pos];
	}
	/// TODO: Need to check return type
	kv* put(Key k, Value v){
		kv* kv = cast(kv*)malloc(kv.sizeof);
		kv.key = k;
		kv.value = v;
		
		size_t pos = SimpleHash(k) % mCapacity;
//		assert(pos < mCapacity, "accessing memory outside of capacity");
		// TODO:
		if(mData[pos] !is null){
			ulong nextSpot=pos;
			// Try next spots
			// TODO: Need to 'wrap around'
			while(nextSpot < mCapacity){
				if(mData[nextSpot] is null){
					pos = nextSpot;
					break;
				}else{
					nextSpot++;
					mCollisionCount++;
				}
			}
		}

		// Add the element
		printf("adding at pos %lu\n",pos);
		mData[pos] = kv;
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
	const(kv**) data() const{
		return this.mData;
	}

	/// TODO: Put in a buffer instead of a 'printf'
	/// TODO: Rename this function to 'print' or something like that.
	string toString(){
		printf("kv: [");
		for(int i=0; i < mCapacity; i++){
			if(mData[i] !is null ){
				// Print out key
				static if(isIntegral!(Key)){
					printf("%d:",mData[i].key);
				}else if(is(Key==string)){
					//printf("%s:",mData[i].key);
				}
				else{
					//printf("%s:",mData[i].key.toString());
				}
				// print out value
				static if(isIntegral!(Value)){
					printf("%d",mData[i].value);
				}else if(is(Value==string)){
					printf("%s:",mData[i].value);
				}else{
					printf("%s",mData[i].value.toString());
				}
				// Handle printing out of commas
				if(i<mCapacity-1 && (mData[i+1] !is null)){
					printf(",");
				}
			}
		}	
		printf("]\n");
		return "";
	}

	// ============ Iterator ========
	int nextKey=0;
	size_t totalKeysIterated=0;
	kv* front(){
		++totalKeysIterated;
		return mData[nextKey];
	}
	void popFront(){
		printf("In popFront\n");
		// Move iterator to the 'nextKey' free slot in the table.
		for(size_t i=nextKey; nextKey < mCapacity; i++){
			if(mData[i] is null){
				nextKey++;
			}else{
				break;
			}
		}
		printf("nextKey is: %d\n",nextKey);
	}
	bool empty() const{
		return totalKeysIterated==mSize;
	}
	// ==============================
}


unittest{
	printf("=== Basic AA test ====\n");
	auto aa = AssociativeArray!(int,int)(16);


	aa.put(5,5);
	aa.put(6,6);
	aa.put(7,7);

	aa.toString();
	printf("Collisions: %lu\n",aa.mCollisionCount);
}

unittest{
	printf("=== string key AA test ====\n");
	auto aa = AssociativeArray!(string,int)(16);

	aa.put("bob",5);
	aa.put("mike",6);

	aa.toString();
	printf("Collisions: %lu\n",aa.mCollisionCount);
}

extern(C) void main()
{
	static foreach(u; __traits(getUnitTests, __traits(parent, main))){
		u();
	}
}
