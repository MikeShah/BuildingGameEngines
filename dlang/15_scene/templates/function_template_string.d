// function_template_string.d
import std.stdio;

auto add(T1,T2)(T1 a, T2 b){
    return a + b;
}

void main(){
    auto resultss = add!(string,string)("mike","shah");

    writeln(resultss, " which is type : ", typeid(resultss));
}
