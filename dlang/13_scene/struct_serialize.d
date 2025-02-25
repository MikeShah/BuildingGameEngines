// @file struct_serialize.d
// Example showing how to 'write' out a struct by each component.
// However -- reading not always as clear!
import std.stdio;

struct GameObject{
		int mID;
		int mNumberOfComponents;

		void WriteToText(ref File f){
				import std.conv;
				if(f.isOpen()){
						f.write(mID.to!string);
						f.write(","); // important to write 'comma' so data is formatted
						f.write(mNumberOfComponents.to!string);
				}
		}
		void WriteToBinary(ref File f){
				if(f.isOpen()){
						f.rawWrite([mID,mNumberOfComponents]);
				}
		}
}

void main(){
		GameObject go1 = GameObject(1,10);
		GameObject go2 = GameObject(2,7);

		// Write the data as binary
		auto writeFileBin = File("struct_serialize.bin","wb");
		go1.WriteToBinary(writeFileBin);
		go2.WriteToBinary(writeFileBin);
		writeFileBin.close();

		auto writeFileText = File("struct_serialize.txt","w");
		go1.WriteToText(writeFileText);
		writeFileText.write("\n");
		go2.WriteToText(writeFileText);
		writeFileText.close();
}
