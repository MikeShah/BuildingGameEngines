// mixin_example.d

struct DataStructure(T){
    T[] data;


    mixin("void PrintData(){ 
            import std.stdio;
                writeln(\"data: \",this.data);
           }"
          );
}

void main(){
    import std.stdio;
    
    DataStructure!int ds;

    ds.data = [1,2,3,4,5,6];

    ds.PrintData();
}
