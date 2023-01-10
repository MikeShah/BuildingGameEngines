// @file ./gameloop_c_style/main.cpp
//
// compile with: g++ -g -Wall main.cpp -o prog
// run with    : ./prog
#include <iostream>

void input(){

}

void update(){
}

void render(){

}

int main(){

    // Function pointers
    // These are pointers that can store the address of
    // a function. This way we can 're-assign' our routines
    // more flexibly.
    void (*inputFunction)(void);
    void (*updateFunction)(void);
    void (*renderFunction)(void);

    inputFunction = &input;
    updateFunction= &update;
    renderFunction = &render;

    while(true){
        inputFunction();
        updateFunction();
        renderFunction();
    }

    return 0;
}


