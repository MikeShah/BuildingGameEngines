// template_specialization.d
import std.stdio;
import std.traits;

auto add(T1,T2)(T1 a, T2 b)
{
    return a + b;
}

// Specialization
// We specify expicitly what the parameter 
// is going to be and implement a new body of code
// for the specific version code 
auto add(T1: string, T2: string)(T1 a, T2 b)
{
    return a ~ b;
}

void main(){
    auto resultss = add!(string,string)("mike","shah");
    auto resultii = add!(int,int)(1,2);

    writeln(resultss, " which is type : ", typeid(resultss));
    writeln(resultii, " which is type : ", typeid(resultii));
}
