// clang++ -std=c++11 threads1.cpp -o threads1 -lpthread
#include <iostream>
// Include the thread library
#include <thread>
using namespace std;

// A simple test function
void test(int x) {
    cout << "Hello from our thread! It prints " << x << "!" << endl;
}

int main() {
// Create a new thread and pass in with one parameter
    thread myThread(&test, 100);
	// Join with the main thread
    myThread.join();
	// Continue executing the main thread
    cout << "Hello from the main thread!" << endl;
    return 0;
}


