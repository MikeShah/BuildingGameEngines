// @file: memory_mapped.d
import std.stdio;
import std.file;
import std.mmfile;

void main(){
		// Remove the memory mapped file that we create
		// once we leave the current scope.
//		scope(exit) remove(deleteme);

		// Note: Scope prevents 'pointer values escaping' the scope. 
		// 			 So this includes things like re-assigning to something
		//        with a 'bigger' scope then here. 
		//       See for more: https://dlang.org/spec/attribute.html#scope
		//       Type is otherwise inferred.
		scope mmfile = new MmFile("delete_this_file", MmFile.Mode.readWriteNew, 48, null);

		writeln(mmfile.length); 

		// Data effectively gives us 'byte -level' access to this data
		auto data = cast(ubyte[]) mmfile[];
		// Try uncommenting the line below and seeing you memory is addressed
		// auto data = cast(int[]) mmfile[]; 

		// This write to memory will be reflected in the file contents
		// In D you can 'assign all' values using this shortcut.
		data[] = '\n';

		// Force updates to file.	
		mmfile.flush();

		// Read out contents of entire file
		writeln(std.file.read("./delete_this_file")); // "\n\n\n\n\n"...
}
