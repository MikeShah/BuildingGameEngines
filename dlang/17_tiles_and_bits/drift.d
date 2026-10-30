// @file: drift.d
import std.stdio;
import std.math.operations;

void main(){
	float sum1=0.0,sum2=0.0,sum3=0.0,sum4=0.0, sum5=0.0;
	for(float f=0.0; f < 100.0f; f+=0.01){
		sum1 += 0.01;
	}
	writeln("sum1= ",sum1);

	for(float f=0.0; f < 100.0f; f+=0.001){
		sum2 += 0.001;
	}
	writeln("sum2= ",sum2);

	for(float f=0.0; f < 100.0f; f+=0.0001){
		sum3 += 0.0001;
	}
	writeln("sum3= ",sum3);

	for(float f=0.0; f < 100.0f; f+=0.00001){
		sum4 += 0.00001;
	}
	writeln("sum4= ",sum4);
	// Just for fun -- showing we don't land on a value of 0.025
	for(float f=0.0; f < 100.0f; f+=0.01){
		sum5 += 0.025;
	}
	writeln("sum5= ",sum5);
}
