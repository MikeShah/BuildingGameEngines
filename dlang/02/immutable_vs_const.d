// @file immutable_vs_const.d
import std.stdio;

void main(){

    // Data
    int data1=555;
    // const pointer to data
    const int*     pdata            = &data1;
    // Effectively through a pointer we can
    // still modify data
    writeln(*pdata); // before: 555
    data1 = 7;
    writeln(*pdata); // after: 7


    int data2=42;
//    immutable int* immutablePData2   = &data2;
    //    ^ The above is not allowed, we can only
    //      point to 'immutable int'


    immutable data3=77;
    immutable int* immutablePData3 = &data3;
//    data3 = 123; // error, cannot modify immutable data
    writeln(data3);


}



