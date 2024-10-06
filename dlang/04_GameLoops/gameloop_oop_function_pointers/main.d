// @file ./gameloop_oop_function_pointers/main.cpp
//
// compile with: dmd -g main.d -of=prog
// compile with: ldc2 -g main.d -of=prog
// run with    : ./prog
import std.stdio;

// Named function pointer that returns 'void' and takes 'void'
// arguments
alias void_void = void function();

void input(){ }

void update(){ }

void render(){ }

struct Application{
    //this()   {}   // Constructor
                    // Note: No parameters, no need to define constructor
    //~this()  {}   // Destructor

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

void main(){

    // Create one instance of the game application
    Application gameApplication;

    gameApplication.SetInputFunction(&input);
    gameApplication.SetUpdateFunction(&update);
    gameApplication.SetRenderFunction(&render);

    // Call the loop function
    gameApplication.loop();
}


