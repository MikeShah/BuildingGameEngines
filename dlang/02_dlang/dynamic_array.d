/// @file dynamic_array.d
import std.stdio;

void main(){
	
		/// Create a dynamic array
		/// by not specifying the size;
		int[] dynamic_array;
		dynamic_array ~= 5; // Append element 5
		writeln(dynamic_array);

		/// initialize dynamic array with 10 elements to start
		int[] dyanmic_array_initial_size_10 = new int[10];
		dyanmic_array_initial_size_10 ~= 11;
		writeln(dyanmic_array_initial_size_10);

		/// Multi-dimensional arrays
		int[][] multidimensional_dynamic_array = new int[][](2,2);
		writeln(multidimensional_dynamic_array);
}
