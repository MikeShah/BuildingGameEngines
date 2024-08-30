// @file ./gameloop_oop/main.d
//
// compile with: dmd -g main.d -of=prog
// compile with: ldc2 -g main.d -of=prog
// run with    : ./prog
import std.stdio;

struct Application{
    //this() {}    // Constructor 
                   // Note: No need to define if not parameters however!

    //~this() {}   // Destructor

    void input(){

    }

    void update(){
    }

    void render(){

    }

    void loop(){
        while(true){
            input();
            update();
            render();
        }
    }
};

void main(){

    // Create one instance of the game application
    Application gameApplication;
    // Call the loop function
    gameApplication.loop();
}


