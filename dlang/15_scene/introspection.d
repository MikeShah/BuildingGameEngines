// @file: introspection.d
// Nice talk showing this trick: https://www.youtube.com/watch?v=rSY78Hu8DqIw

import std.traits;
import std.stdio;

struct Component{
    float a,b,c;
}

struct SomeType{
    int i;
    float f;
    Component c;
}

struct Type(T){

    this(int oneValue){}

    // Examples this constructor argument out to a dynamic array
    // automatically
    this(T[]...){

    }
}

@UDA struct UDA{}

@UDA struct ClientMessage{
    int id;
}

@UDA struct ServerMessage{
    int id;
}

void main(){

    pragma(msg,"=== Finding UDAs ====");
    alias clientMessages = hasUDA!(ClientMessage,UDA);
    alias server= hasUDA!(ServerMessage,UDA);
    pragma(msg,clientMessages);
    pragma(msg,server);
    pragma(msg,"=======");

    alias AllParams = __traits(allMembers, SomeType);
    pragma(msg,AllParams);

    // Map of parameters
    bool[string] SetParams;
    foreach(idx, name; AllParams){
        
        //mixin("enum ThisParam = AllParams."~name~";");
        SetParams[name.stringof] = true;
    }

    writeln(SetParams);
}
