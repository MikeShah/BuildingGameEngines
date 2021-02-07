// Directions: 
//
// Compile with: clang++ -std=c++14 locality.cpp -o locality
// g++ will also work fine
// Visual Studio 2017 should also work fine
//
#include <iostream>	// Useful library for output
#include <chrono> 	// Useful library for timing

#define testdatatype long long

// Singly linked list
template <typename myType>
struct Node{
	Node<myType>* m_pNext;
	myType m_Data;
};


int main(){

// ==================== Configuration ================
	int containerSize = 1000000;
	std::chrono::steady_clock::time_point start1;
	std::chrono::steady_clock::time_point start2;
	std::chrono::steady_clock::time_point end1;
	std::chrono::steady_clock::time_point end2;

// ==================== Configuration ================


// ==================== Data Structure Setup ================
  // 1. Setup the Linked List

	// Create a single node
	Node<testdatatype>* myLinkedList = new Node<testdatatype>;
	// Create a node to iterate through our list
	Node<testdatatype>* iter = myLinkedList;
	// Create a simple linked list through iteration
	for(int i =0; i < containerSize/2; ++i){
		// Create a new node
		Node<testdatatype>* newNode = new Node<testdatatype>;
		// point node to newNode
		iter->m_pNext = newNode;
		// Set new nodes attributes
		newNode->m_Data = i;
		newNode->m_pNext = NULL;
		iter=newNode;
	}

  // 2. Setup the array (i.e. create some more memory
	testdatatype myArray[containerSize];
	for(int i=0; i < containerSize; ++i){
		myArray[i] = i;
	}

 // 3. Setup the other "half" of our Linked List
	for(int i =0; i < containerSize/2; ++i){
		// Create a new node
		Node<testdatatype>* newNode = new Node<testdatatype>;
		// point node to newNode
		iter->m_pNext = newNode;
		// Set new nodes attributes
		newNode->m_Data = i;
		newNode->m_pNext = NULL;
		iter=newNode;
	}
// ==================== Data Structure Setup ================


	// Time the traversal of a linked list
	// What do you think is costing time?
	iter = myLinkedList;
	start1 = std::chrono::steady_clock::now();	
	while(iter!=NULL){
		// You can uncomment if you like, but I recommend
		// reducing the containerSize.
		//std::cout << iter->m_pNext << ":" << iter->m_Data << "\n";
		iter=iter->m_pNext;
	}
	end1 = std::chrono::steady_clock::now();	
	

	// Time the traversal of array
	start2 = std::chrono::steady_clock::now();	
	for(int i =0; i < containerSize; ++i){
		myArray[i];
	}
	end2 = std::chrono::steady_clock::now();	


	std::cout << "Linked List Traversal: " << std::chrono::duration_cast<std::chrono::microseconds>(end1-start1).count() << "\n";	

	std::cout << "Array Traversal: " << std::chrono::duration_cast<std::chrono::microseconds>(end2-start2).count() << "\n";	

	return 0;
}
