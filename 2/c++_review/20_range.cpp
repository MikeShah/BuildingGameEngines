// clang++ 1_range.cpp -o range

#include <iostream>


int main(int argc, char* argv[] ){

    int data[] = {1,2,3,4};

    for(auto e : data){
        std::cout << e << std::endl;
    }

    return 0;
}
