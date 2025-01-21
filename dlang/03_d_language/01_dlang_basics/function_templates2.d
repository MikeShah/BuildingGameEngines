// @file dlang_basics/function_templates2.d
import std.stdio;
import std.traits;

auto Add(T)(T a, T b)
    if(isBasicType!(T))
{
    return a+b;
}

void main(){

   auto result1 =  Add!(int)(1,4);
   writeln(result1);

    
   auto result2 =  Add!(double)(1.5,4.3);
   writeln(result2);

}
