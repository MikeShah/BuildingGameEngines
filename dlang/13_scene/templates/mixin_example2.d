// mixin_example2.d

mixin(import("DataStructure.txt"));


void main(){
    import std.stdio;
    
    DataStructure!int ds;

    ds.data = [1,2,3,4,5,6];

    ds.PrintData();
}
