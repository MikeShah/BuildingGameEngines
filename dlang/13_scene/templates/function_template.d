// function_template.d
import std.stdio;

T add(T)(T a, T b){
    return a + b;
}

void main(){
    auto resulti = add!int(5,4);
    auto resultf = add!float(7.0f,5.0f);
    auto resultl = add!long(72,51);
    auto resultd = add!double(7.2,5.2);

    writeln(resulti, " which is type : ", typeid(resulti));
    writeln(resultf, " which is type : ", typeid(resultf));
    writeln(resultl, " which is type : ", typeid(resultl));
    writeln(resultd, " which is type : ", typeid(resultd));
}
