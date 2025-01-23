// @file: package_example/main.d
// Compile and run: rdmd main.d
import mathpackage.general.funcs;
import mathpackage.linear.matrix;
import mathpackage.linear.vector;

// This imports all of the above packages.
import mathpackage;
// In order to have this 'convenient form'
// You need to define a 'package.d'
// file within the 'mathpackage' folder.

void main(){
	Vector3 v;
	Matrix4x4 m;

	addf(7.0f,2.0f);
}
