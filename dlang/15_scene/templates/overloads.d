// overloads.d
import std.stdio;

int add(int a, int b){
    return a + b;
}

float add(float a, float b){
    return a + b;
}

void main(){
    auto resulti = add(5,4);
    auto resultf = add(7.0f,5.0f);

    writeln(resulti, " which is type : ", typeid(resulti));
    writeln(resultf, " which is type : ", typeid(resultf));
}
