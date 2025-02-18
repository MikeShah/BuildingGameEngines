// @file: bit.d
import std.stdio;

void main(){

		// Binary value for 
		ubyte value = 0b00001111;
		writef("Value: %d, binary: %b\n",value,value);
		// Shift to the write one
		ubyte dropAbit = value >> 1;
		writef("Value: %d, binary: %b\n",dropAbit,dropAbit);
	
		// Shift to the left to multiply
		// NOTE: D compiler may complain if you don't 'upcast' to a
		//       larger type in order to avoid 'overflow'
		ushort multiply = dropAbit << 1;
		writef("Value: %d, binary: %b\n",multiply,multiply);

}
