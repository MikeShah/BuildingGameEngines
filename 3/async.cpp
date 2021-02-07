//  Compile on Ubuntu Bash shell
//
// clang++ -std=c++14 async.cpp -o async -lpthread
//           ^ We need c++11 or above for <future> library
//           ^ We also need the pthread library
#include <iostream>
#include <string>
#include <future> // The async functions
// Libraries used to 'simulate' sleeping
#include <chrono>
#include <thread>

// Sleep in a current thread
void sleepMS(unsigned int x){
	std::this_thread::sleep_for(std::chrono::milliseconds(x));
}

// This is our 'file loading' function
bool fileLoaded(std::string filename){

	int bytesLoaded = 0;
	while(bytesLoaded < 10){
		std::cout << "Loading file: " << filename << "\n";
		sleepMS(500);
		++bytesLoaded;
	}

	return true;
}


int main(int argc, char** argv){

	// Creates another thread and launches it
	std::future<bool> fu = std::async(std::launch::async, fileLoaded, "my3Dobject.obj");

	unsigned int counter = 0;
	while(counter < 5){
		std::cout << "Game is loading resources\n";
		sleepMS(1000);
		++counter;
	}



	return 0;
}
