module linear.vec2;

import std.math;

struct vec2{
		union{
				float[2] elements = [0.0f,0.0f];
				struct{
						float x,y;
				}
		}
		alias elements this;;


		this(float x, float y){
			this[0] = x;
			this[1] = y;
		}

		vec2 opBinary(string op)(vec2 rhs){
				static if(op=="+" || op=="-"){
						vec2 result;
						mixin("result[0] = this[0] "~op~" rhs[0];");
						mixin("result[1] = this[1] "~op~" rhs[1];");
						return result;
				}
				assert(0,"illegal opBinary operation");
		}

		vec2 opBinary(string op)(float rhs){
				static if(op=="*" || op=="/"){
						vec2 result;
						mixin("result[0] = this[0] "~op~" rhs;");
						mixin("result[1] = this[1] "~op~" rhs;");
						return result;
				}
				assert(0,"illegal opBinary operation");
		}

		vec2 opUnary(string op)(){
				static if(op=="-"){
						this[0] = -this[0];
						this[1] = -this[1];
						return this;
				}
				assert(0,"illegal opUnary operation");
		}

		float Length(){
			return sqrt(this[0]*this[0] + this[1]*this[1]);
		}

		/// Returns a unit vector from the current vector, but does not modify the vector otherwise
		/// This can be particularly helpful if you want to use the intermediate result, or otherwise use
		/// this as a helper function without mutating the actual vector.
		vec2 GetUnitVector(){
			vec2 result;
			result[0] = this[0] / Length();	
			result[1] = this[1] / Length();	
			return result;
		}

		// Makes the current vector a unit vector
		vec2 Normalize(){
			this = GetUnitVector();
			return this;	
		}
}


float DegreeToRadians(float degrees){
	return degrees * std.math.PI / 180.0f;
}

float RadiansToDegrees(float radians){
	return (180.0f * radians) / std.math.PI;
}

vec2 RotateVector(vec2 v, float degrees){
	float radians = DegreeToRadians(degrees);
	float cosine = cos(radians);
	float sine = sin(radians);

	vec2 result;
	result[0] = v.x*cosine - v.y*sine;
	result[1] = v.x*sine + v.y*cosine;

	return result;
}

float Dot(vec2 a, vec2 b){
	return a.x*b.x + a.y *b.y;
}

// Computes the angle in radians between two vectors
float EnclosedAngleInRadians(vec2 a, vec2 b){
	vec2 unit_a = a.GetUnitVector();
	vec2 unit_b = b.GetUnitVector();

	float dotp = Dot(unit_a,unit_b);
	return acos(dotp);
}

// Compute the angle in degrees between two vectors
float EnclosedAngleInDegrees(vec2 a, vec2 b){
	return RadiansToDegrees(EnclosedAngleInRadians(a,b));
}

/// Project vector 'v' to another vector 'onto')
vec2 Project(vec2 v, vec2 onto){
	// Shortcut for checking if length of
	// vector we are projecting onto is greater
	// than zero.
	float d = Dot(onto,onto);
	if(d > 0){
		// Compute the scalar product (i.e. dot product)
		float dp = Dot(v, onto);
		return onto * (dp / d);
	}
	assert(0,"projecting onto vector of length 0");
}


