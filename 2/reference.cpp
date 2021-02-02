// reference.cpp

#include <iostream>

// Normal way to pass a variable in
// This makes a copy of 'a' on the stack and then
// a is reclaimed after execution.
void setValuePassByValue(int a){
    a = 7777;
}

// Pass by 'reference', so 'a' is an alias
// for the actual variable being passed in.
// This means we are indeed modifying it.
void setValuePassByReference(int &a){
    a = 8888;
}

// Pass by value, and use a pointer as the argument.
// The pointer stores the actual address of the variable
// so we can 'indirectly' modify that value at that address.
// Keep in mind 'int* a' is still a copy of the pointer,
// so one copy of the pointer is made, but we can still
// modify the value of the variable being passed in.
void setValuePassByValueWithPointer(int* a){
    *a = 7777;
}

int main(){

    int x = 1;
    int y = 2;
    int z = 3;

    // Pass in a copy of x into our function
    setValuePassByValue(x);

    // Pass by reference 'y'
    setValuePassByReference(y);

    // Pass by value 'z', but pass as a pointer,
    // so we need to pass in the address of z.
    setValuePassByValueWithPointer(&z);

    std::cout << "x: " << x << std::endl;
    std::cout << "y: " << y << std::endl;
    std::cout << "z: " << z << std::endl;

    return 0;
}




