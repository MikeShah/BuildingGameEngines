// clang++ -std=c++11 11_class.cpp -o class
#include <iostream>

class GameObject{
    public:
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
