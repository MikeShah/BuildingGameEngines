// template_constraint.d
import std.stdio;
import std.traits;

// https://dlang.org/articles/constraints.html
// __traits specifically runs at compile-time to see if this
//          function is able to compile and thus legal code.
const isAddable(T) = __traits(compiles,(T t){ return t+t;});

auto add(T1,T2)(T1 a, T2 b)
    if (isAddable!(T1) && isAddable!(T2))
{
    return a + b;
}

void main(){
    auto resultss = add!(string,string)("mike","shah");
//    auto resultss = add!(int,int)(1,2);

    writeln(resultss, " which is type : ", typeid(resultss));
}
