// @file: pool.d 
struct GenericPool(T, uint SIZE){
	T[SIZE] 	 mObjectPool;
	bool[SIZE] mObjectInUse;

	size_t GetNextFreeObjectIndex(){
		/* search or do bookkeeping for next free index */
	}
}

struct Particle{
	float x,y,z;
}

void main(){
	auto particleSystem = GenericPool!(Particle,100)(); 
}
