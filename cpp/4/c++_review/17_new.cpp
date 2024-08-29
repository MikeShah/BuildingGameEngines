// clang++ -std=c++11 17_new.cpp -o new2
struct Vector3{
    float x,y,z;
};

int main(){
    // (1) Give me memory for 50 Vector3's
    // Gives me a chunk of contiguous memory
    // for 50 Vector3's    
    Vector3* directions = new Vector3[50];

    // (2) Delete the array 'direction'
    // Note the brackets []'s, indidcating this is more than
    // one item--we have 50! Omitting the brackets gives us
    // a memory leak!
    delete[] directions;

    return 0;
}
