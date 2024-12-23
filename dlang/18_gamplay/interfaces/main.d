// interfaces/main.d
import std.stdio;

interface IRenderable{
    void Render(/* SDL_Renderer ... */);
}
interface IInputEnabled{
    void Input();
}
interface IScript{
    void Update();
}

// Note: See the 'added' members that must be implemented from
//       the 'multiple interfaces'
class MyCustomScript : IScript, IRenderable, IInputEnabled{
    void Update(){
        writeln("MyCustomScript.Update");
    }

    void Render(){
        writeln("MyCustomScript.Render");
    }

    void Input(){
        writeln("MyCustomScript.Input");
    }
}
// Simple script without any 'decorations'
class MySimpleScript : IScript{
    void Update(){
        writeln("MySimpleScript.Update");
    }
}

struct GameObject{
    IScript[] mScripts;
}

void main(){

    IScript        s1 = new MySimpleScript; 
    MyCustomScript s2 = new MyCustomScript;

    GameObject g;
    g.mScripts ~= s1;
    g.mScripts ~= s2;

    foreach(s ; g.mScripts){
        // Need to check if cast was successful
        if(cast(MyCustomScript)s){
            // If cast is successful, then call member functions on the casted script
            MyCustomScript c = cast(MyCustomScript)s;
            c.Input();
            c.Update();
            c.Render();
        }else{
            s.Update();
        }
    }
}
