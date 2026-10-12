// function_template_string.d
//
// NOTE: This example is meant 'not to compile'.
//       See the template_specialization.d example
import std.stdio;

auto add(T1,T2)(T1 a, T2 b){
    return a + b;
}

void main(){
    auto resultss = add!(string,string)("mike","shah");

    writeln(resultss, " which is type : ", typeid(resultss));
}
