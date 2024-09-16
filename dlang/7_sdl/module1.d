// @file module1.d

// Observe that the module name is by default the
// filename (without the .d extension)
module module1;


void main(){
    import std.stdio;

    writeln("Special keywords:");
    writeln("__MODULE__         : ",__MODULE__);
    writeln("__FILE__           : ",__FILE__);
    writeln("__FILE_FULL_PATH__ : ",__FILE_FULL_PATH__);
    writeln("__FUNCTION__       : ",__FUNCTION__);
    writeln("__PRETTY_FUNCTION__: ",__PRETTY_FUNCTION__);

    writeln("This is module1"); 
}

