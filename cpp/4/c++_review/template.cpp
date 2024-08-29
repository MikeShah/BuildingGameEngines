// template.cpp
#include <iostream>

template<class T>
T square(T x){
    return x*x;
}

int main(){
    
    std::cout << square<int>(5) << std::endl;
    std::cout << square<float>(5.1) << std::endl;

    return 0;
}



