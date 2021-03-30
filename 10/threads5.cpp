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
    cout << "program is continuing at this point\n";
    // some other work here
    // ...
    // ...
    // But now I really need to make sure
    // I have the value from 'a', so I call .get().
    int v = a.get();

    cout << "The thread returned " << v << endl;
    return 0;
}


