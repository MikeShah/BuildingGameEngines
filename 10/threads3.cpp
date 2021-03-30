// clang++ -std=c++11 threads3.cpp -o threads3 -lpthread
#include <iostream>
#include <vector>
#include <thread>
#include <atomic>
using namespace std;

// How many threads we are including
#define THREAD_COUNT 200
#define INCREMENT 1
atomic<int> accum(0);

void add(int x) {
    accum += 1;
}

int main() {
    vector<thread> ths;
    for (int i = 0; i < THREAD_COUNT; i++) {
        ths.push_back(thread(&add, INCREMENT));
    }

    for (auto& th : ths) {
        th.join();
    }
    cout << "accum = " << accum << endl;
    return 0;
}


