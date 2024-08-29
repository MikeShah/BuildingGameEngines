// clang++ -std=c++11 12_struct.cpp -o struct
#include <iostream>

struct GameObject{
    // Constructor
    GameObject(){ }
    // Destructor
    ~GameObject(){ }

    private:
    int value; // member variable
};


int main(){
    // Instance of our class
    GameObject mario; // 'mario' is an object
    GameObject luigi; // the type of mario is 'GameObject'

    return 0;
}
