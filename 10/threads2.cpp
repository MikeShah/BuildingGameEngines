// clang++ -std=c++11 threads2.cpp -o threads2 -lpthread
#include <iostream>
#include <vector>
#include <thread>
#include <mutex>
using namespace std;

mutex accum_mutex;

// How many threads we are including
#define THREAD_COUNT 200
#define INCREMENT 1

int accum = 0;

void add(int x) {
	accum_mutex.lock();
    	accum += 1;
	accum_mutex.unlock();
}

int main() {
    vector<thread> threads;
    for (int i = 0; i <= THREAD_COUNT; i++) {
        threads.push_back(thread(&add, INCREMENT));
    }

    for (auto& th : threads) {
        th.join();
    }
    cout << "accum = " << accum << endl;
    return 0;
}


