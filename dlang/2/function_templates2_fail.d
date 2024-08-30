// @file function_templates2_fail.d
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

    
   auto result2 =  Add!(string)("hello","world");
   writeln(result2);

}
