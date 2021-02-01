// clang++ -std=c++11 14_mem.cpp -o 14_mem
#include <iostream>

void setValue(int a){
    a = 9999;
}

int main(){
    int x = 42;
    setValue(x);
    std::cout << "x is " << x << '\n';

    return 0;
}
