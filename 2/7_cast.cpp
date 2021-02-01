// clang++ -std=c++11 7_cast.cpp -o static
#include <iostream>

void printInt(int a){
    std::cout << "Here's an int: " << a << std::endl;
}

int main(){

    long smallNumber = 9;
    // I have to definitely be sure data will be an int at compile-time    
    printInt( static_cast<int>(smallNumber)); 
    // Let's cast at run-time if I am not 100% what will be coming in
    printInt( int(smallNumber) );

    return 0;
}
