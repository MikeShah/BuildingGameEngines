/// @file basic_types.d 

import std.stdio;

void main(){

    int value;
    writeln(value); // deafult initialized
    writeln(value.init); // deafult value 
                         // for int's when
                         // initialized
    writeln();

    /// Other default types and their 
    /// 'sizeof' property
    writeln(bool.sizeof);
    writeln(byte.sizeof);
    writeln(ubyte.sizeof);
    writeln(char.sizeof);
    writeln(short.sizeof);
    writeln(ushort.sizeof);
    writeln(wchar.sizeof);
    writeln(int.sizeof);
    writeln(uint.sizeof);
    writeln(dchar.sizeof);
    writeln(long.sizeof);
    writeln(ulong.sizeof);
    writeln(float.sizeof);
    writeln(double.sizeof);
    writeln(real.sizeof); 
}



