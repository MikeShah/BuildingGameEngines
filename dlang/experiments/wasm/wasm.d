/* 

To test locally:
python3 -m http.server 1024

Navigate to wasm.html page
*/

import std.algorithm;

extern(C): // disable D mangling

interface Test(){
    void someFunction();
}

//class test{
//    int field;
//}


double add(double a, double b){
    return a +b;
}

auto testFunc(){
    int[] collection = [1,2,3,4,5];
    foreach(ref elem; collection){
        elem++;
    }
}

void _start(){

}
