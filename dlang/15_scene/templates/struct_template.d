// struct_template.d
// Run with args "-vcg-ast" to see what is generated
// This will generate struct_template.d.cg

struct DataStructure(T){
    T[] data;
}

void main(){
    import std.stdio;
    
    DataStructure!int ds;
    DataStructure!float dsFloat;

    ds.data = [1,2,3,4,5,6];
    dsFloat.data = [1.0f,2.0f];

    writeln(ds.data);
    writeln(dsFloat.data);
}
