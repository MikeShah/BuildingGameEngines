// noTemplate.d
import std.stdio;

int addi(int a, int b){
    return a + b;
}

float addf(float a, float b){
    return a + b;
}

void main(){
    auto resulti = addi(5,4);
    auto resultf = addf(7.0f,5.0f);

    writeln(resulti, " which is type : ", typeid(resulti));
    writeln(resultf, " which is type : ", typeid(resultf));
}
