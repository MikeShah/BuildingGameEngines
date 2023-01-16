// clang++ -std=c++11 16_new.cpp -o new
struct Vector3{
    float x,y,z;
};

int main(){
    // (1) Give me memory for 1 new Vector3
    // This is a pointer, because we are pointing
    // to a chunk of memory big enough for one Vector3.
    // The size of memory requested, is big enough
    // for 3 floats.
    Vector3* direction = new Vector3;

    // (2) Delete the 'direction'
    // We are done with our direction at this point.
    delete direction;

    return 0;
}
