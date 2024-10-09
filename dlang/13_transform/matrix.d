// @file: matrix.d
struct Mat3{
	// Initialize always with identity matrix unless otherwise specified
	float[3][3] e = [[1.0f, 0.0f, 0.0f],
									 [0.0f, 1.0f, 0.0f],
									 [0.0f, 0.0f, 1.0f]];

	// Construct each element
	this(float e00, float e01, float e02,
			 float e10, float e11, float e12,
			 float e20, float e21, float e22){
		e[0][0] = e00;		e[0][1] = e01;		e[0][2] = e02;
		e[1][0] = e10;		e[1][1] = e11;		e[1][2] = e12;
		e[2][0] = e20;		e[2][1] = e21;		e[2][2] = e22;
	}

	// Index to get the column 
	float[3] opIndex(size_t col){
		if(col==0){
			return [e[0][0],e[1][0],e[2][0]];
		}else	if(col==1){
			return [e[0][1],e[1][1],e[2][1]];
		}else{
			return [e[0][2],e[1][2],e[2][2]];
		}
	}
}

void main(){
import std.stdio;
	Mat3 identity;
	// Access each row
	writeln("col 0:",identity[0]);
	writeln("row 0:",identity.e[0]);
	writeln("col 1:",identity[1]);
	writeln("row 1:",identity.e[1]);
	writeln("col 2:",identity[2]);
	writeln("row 2:",identity.e[2]);

	writeln;

	Mat3 m = Mat3(1,2,3,4,5,6,7,8,9);
	// Access each row
	writeln("col 0:",m[0]);
	writeln("col 1:",m[1]);
	writeln("col 2:",m[2]);
	writeln("row 0:",m.e[0]);
	writeln("row 1:",m.e[1]);
	writeln("row 2:",m.e[2]);

}
