// function_template_improved.d
import std.stdio;

auto add(T1,T2)(T1 a, T2 b){
    return a + b;
}

void main(){
    auto resultif = add!(int,float)(5,4.01f);
    auto resultff = add!(float,float)(5.1,4.2f);
    auto resultii = add!(int,int)(7,5);

    writeln(resultif, " which is type : ", typeid(resultif));
    writeln(resultff, " which is type : ", typeid(resultff));
    writeln(resultii, " which is type : ", typeid(resultii));
}
