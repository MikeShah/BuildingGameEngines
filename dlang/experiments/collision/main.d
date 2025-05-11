import linear;

void main(){
		import std.stdio;

		vec2 v;
		writeln(v);

		v[0] = 5.0f;
		v.y = 6.0f;

		writeln(v);

		vec2 v1;
		v = v1 + v;
		v = v1 - v;
		-v;
		v = v * 2.0f;

		writeln(v);
		writeln(v.GetUnitVector(), " length is: ", v.GetUnitVector().Length());
		writeln(v.Normalize());

		writeln(DegreeToRadians(90));
		writeln(RadiansToDegrees(1.5708));


	  vec2 xaxis = vec2(1,0);
		xaxis = RotateVector(xaxis, 90);
		writeln(xaxis);
		writeln(v.Length());

		vec2 xaxis2 = vec2(1,0);
		vec2 yaxis2 = vec2(0,1);
		writeln("Angle is(radians): ",EnclosedAngleInRadians(xaxis2,yaxis2));
		writeln("Angle is(degrees): ",EnclosedAngleInDegrees(xaxis2,yaxis2));


		vec2 onto = vec2(12,5);
		vec2 a = vec2(5,6);
		writeln("Projection: ",Project(a,onto));

}
