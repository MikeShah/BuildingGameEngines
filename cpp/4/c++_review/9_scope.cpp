// clang++ -std=c++11 9_scope.cpp -o scope2
#include <iostream>

class SomeObject{
public:
    // constructor -- called on object creation
    SomeObject(){ std::cout << "created\n"; }
    // destructor -- called when object is destroyed
    ~SomeObject(){ std::cout << "destroyed!\n"; }
};

int main(){
    // For objects, the destructor is called automatically
    // when an object is destroyed (i.e. deleted or leaves scope).
    {
        SomeObject testObject;
    } 
    return 0;
}
