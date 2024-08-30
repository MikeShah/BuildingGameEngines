// @file ./gameloop_c_style/main.d
//
// compile with: dmd -g main.d -of=prog
// compile with: ldc2 -g main.d -of=prog
// run with    : ./prog
import std.stdio;

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
    void function() inputFunction  = null;
    void function() updateFunction = null;
    void function() renderFunction = null;
    // Here's the C-equivalent below' -- much uglier than in D.
    // void (*inputFunction)(void);
    
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


