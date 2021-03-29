// clang++ -std=c++11 threads5.cpp -o threads5 -lpthread
#include <iostream>
#include <future>
#include <chrono>
using namespace std;

int square(int x) {
    return x * x;
}

int main() {
    auto a = async(&square, 10);
    int v = a.get();

    cout << "The thread returned " << v << endl;
    return 0;
}


