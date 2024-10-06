// @file function_templates.d
import std.stdio;

auto Add(T)(T a, T b){
    return a+b;
}

void main(){

   auto result1 =  Add!(int)(1,4);
   writeln(result1);

    
   auto result2 =  Add!(double)(1.5,4.3);
   writeln(result2);

}
