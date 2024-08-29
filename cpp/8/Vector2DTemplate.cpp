// compile: clang++ -std=c++11 Vector2DTemplate.cpp -o example
// run: ./example
#include <iostream>

// Small example of C++ templates
template <class T>
struct Vector2D{
    T x,y;

    Vector2D() = default;

    Vector2D(T _x, T _y):x(_x),y(_y){
    }

};

int main(){

    Vector2D<int> myVecInt(1,2);
    Vector2D<bool> myVecBool(true,false);

    return 0;
}
