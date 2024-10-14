// @file simple_serialize.d
import std.stdio;

void main(){

    auto configdata1 = [1,2,3,4,5,6];
    auto configdata2 = [1.1f,2.1f,3.1f,4.1f,5.1f,6.1f];

    auto writeFileVar = File("simple_serialize.bin","w");

    // Write the data as binary
    writeFileVar.rawWrite(configdata1);
    writeFileVar.rawWrite(configdata2);

    // Close file when we are done with it
    writeFileVar.close();

    // Read the data as binary
    auto myRead = File("simple_serialize.bin","r");

    auto cfd1 = myRead.rawRead(new typeof(configdata1[0])[configdata1.length]); 
    auto cfd2 = myRead.rawRead(new typeof(configdata2[0])[configdata2.length]); 

    writeln("cfd1: ", cfd1);
    writeln("cfd2: ", cfd2);
}
