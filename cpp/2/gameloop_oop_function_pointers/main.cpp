// @file ./gameloop_oop_function_pointers/main.cpp
//
// compile with: g++ -g -Wall main.cpp -o prog
// run with    : ./prog
#include <iostream>

// Named function pointer that returns 'void' and takes 'void'
// arguments
typedef void (*void_void)(void);

void input(){ }

void update(){ }

void render(){ }

struct Application{
    Application()   {}    // Constructor

    ~Application()  {}   // Destructor

    void loop(){
        while(true){
            pfn_input();
            pfn_update();
            pfn_render();
        }
    }

    void SetInputFunction(void_void func){
        pfn_input = func;
    }
    void SetUpdateFunction(void_void func){
        pfn_update = func;
    }
    void SetRenderFunction(void_void func){
        pfn_render = func;
    }

    // Member variables
    void_void pfn_input;
    void_void pfn_update;
    void_void pfn_render;
};

int main(){

    // Create one instance of the game application
    Application gameApplication;

    gameApplication.SetInputFunction(&input);
    gameApplication.SetUpdateFunction(&update);
    gameApplication.SetRenderFunction(&render);

    // Call the loop function
    gameApplication.loop();

    return 0;
}


