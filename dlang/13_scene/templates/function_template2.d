// function_template2.d
import std.stdio;

T1 add(T1, T2)(T1 a, T2 b){
    return a + b;
}

void main(){
    auto resultfi = add!(float, int)(5.0f,4);
    auto resultif = add!(int, float)(7   ,5.0f);

    writeln(resultfi, " which is type : ", typeid(resultfi));
    writeln(resultif, " which is type : ", typeid(resultif));
}
