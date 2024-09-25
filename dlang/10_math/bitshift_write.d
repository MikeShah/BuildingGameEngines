// @file: bitshift_write.d
import std.stdio;

void main(){

		//int pixel = 0xFFEE00BB;
		int pixel = 0x00000000;

		ubyte r = 0xFF;
		ubyte g = 0xEE;
		ubyte b = 0x00;
		ubyte a = 0xBB;

		// Shift in each byte
		pixel = (a) + (b <<8) + (g << 16) + (r << 24);

		writef("value%d, hex: %x\n",pixel,pixel);

		// Use D's 'slicing' to read/write bytes
		ubyte* bytes = cast(ubyte*)&pixel;
		writeln("r:",bytes[3..4]);
		writeln("g:",bytes[2..3]);
		writeln("b:",bytes[1..2]);
		writeln("a:",bytes[0..1]);
}
