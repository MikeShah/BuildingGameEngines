// @file: bitmasking.d
import std.stdio;

void main(){
		// A 'bit mask' for operations for clearing or
		// otherwise setting bits. 
		ubyte mask = 0b00001111;

		ubyte value1 = 0b11111111;
		ubyte value2 = 0b11111111;
		ubyte value3 = 0b11111111;

		// 'or' with bits
		value1 = value1 | mask;
		// Clear bits by 'and'ing' with our mask
		value2 = value2 & mask;
		// Flip bits with exclusive or
		value3 = value3 ^ mask;

		writef("Value: %d\t binary: %b\n",value1,value1);
		writef("Value: %d\t binary: %b\n",value2,value2);
		writef("Value: %d\t binary: %b\n",value3,value3);
}
