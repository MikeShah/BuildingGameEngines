// @file: static_storage.d
auto pre_compute(long Table_Size)(){
	if(__ctfe){
			import std.array;
			
			auto app = appender!(long[]);
			foreach(i; 0 .. Table_Size){
					app.put(i);
			}
			return app.data;
	
			pragma(msg,"Ran in compile-time, and stored in binary");
	}else{
		import std.stdio;
		writeln("Running at run-time");
		return new long[Table_Size];
	}
}

enum PreComputedTable = pre_compute!50000;

void main(){


}
