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
    // Threads that do not currently hold the mutex
    // must wait here and try to acquire the lock
    accum_mutex.lock();
    	accum += x;
	accum_mutex.unlock();
}

int main() {
    // Create a vector to hold all of our threads
    vector<thread> threads;

    // Create THREAD_COUNT number of threads
    for (int i = 0; i < THREAD_COUNT; i++) {
        threads.push_back(thread(&add, INCREMENT));
    }

    // Join all of our threads with the main
    // thread--thus waiting until our program
    // finishes
    for (auto& th : threads) {
        th.join();
    }

    // Report the result
    cout << "accum = " << accum << endl;

    return 0;
}


