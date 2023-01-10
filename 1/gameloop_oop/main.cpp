// @file ./gameloop_oop/main.cpp
//
// compile with: g++ -g -Wall main.cpp -o prog
// run with    : ./prog
#include <iostream>

struct Application{
    Application() {}    // Constructor
    ~Application() {}   // Destructor

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

int main(){

    // Create one instance of the game application
    Application gameApplication;
    // Call the loop function
    gameApplication.loop();

    return 0;
}


