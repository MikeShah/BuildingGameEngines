// @file vec2.d
module vec2;

import std.math;
import std.stdio;
import std.traits;


// Common alias for types
// Note: I was tempted to break convention and use a 'lowercase' type name that
//       matches the naming convention of graphics language type names.
//       However, that is 'surprising' to the user and inconsistent.
alias Vec2f = Vec2!float;
alias Vec2i = Vec2!int;

// Create a Vector using primitive types of integral or floating point.
// The dimensions can also be specified
//
// Note: In many of the member functions, you will observe the return type
// 			 of either 'T' or 'typeof(this)'. Why? The reason why is because
//       we want to be able to 'chain' together operations with a vector
//       using the universal function call syntax.
struct Vec2(T)
		// Template Constraint esnures only integral types
		// are supplied as template arguments during creation.
if(__traits(isIntegral,T) || __traits(isFloating,T)) 
{
		// Internal Data
		// Note: It's convenient to be able to access 
		//       in different ways to provide context to the user
		//       about what problem you're trying to solve.
		// Note: It's important to initialize these values. 
		//       If you have a float type that initializes to NaN,
		//       you will indeed get lots of assertion errors.
		// Note: When you print out a union, or data structure with a union,
		//       D will show you all of the union, but again remember, that
		//       the size of the type is not what you see.
		union{
				struct{
						T x=0,y=0;
				}
				struct{
						T s,t;
				}
				struct{
						T i,j;
				}
				struct{
						T[2] elem;
				}
		}

		// Support for slicing
		ref T opIndex(size_t index){
				return elem[index];
		}

		// Support negation
		// This 'flips' the direction of the vector.
		ref typeof(this) opUnary(string op)() {
				static if(op=="-"){
						x=-x;
						y=-y;			
				}else static if(op=="++" || op=="--"){
						mixin("x = "~op~"x;");
						mixin("y = "~op~"y;");
				}
				return this;
		}	

		// Support binary overloads for + and -
		// Note: Why use 'typeof(this)' instead of just writing out 'Vec2!T'?
		//       What if we later decide to change the type?
		ref typeof(this) opBinary(string op)(typeof(this) rhs){
				static if(op=="+" || op=="-"){
						mixin("x = x"~op~"cast(T)rhs.x;");	
						mixin("y = y"~op~"cast(T)rhs.y;");	
				}
				return this;
		}

		// Support binary overloads for * and / 
		// Note: This is for 'scalar multiplication/division'
		ref typeof(this) opBinary(string op)(double rhs){
				static if(op=="*" || op=="/"){
						mixin("x = x"~op~"cast(T)rhs;");	
						mixin("y = y"~op~"cast(T)rhs;");	
				}
				return this;
		}

		// Support binary overloads for += and -=
		// Note: Why use 'typeof(this)' instead of just writing out 'Vec2!T'?
		//       What if we later decide to change the type?
		ref typeof(this) opOpAssign(string op)(typeof(this) rhs){
				static if(op=="+" || op=="-"){
						mixin("x "~op~"= cast(T)rhs.x;");	
						mixin("y "~op~"= cast(T)rhs.y;");	
				}
				return this;
		}

		// Support binary overloads for *= and /=
		// Note: This is for 'scalar multiplication/division'
		ref typeof(this) opOpAssign(string op)(double rhs){
				static if(op=="*" || op=="/"){
						mixin("x "~op~"= cast(T)rhs;");	
						mixin("y "~op~"= cast(T)rhs;");	
				}
				return this;
		}

		// Magnitude of vector
		// Intuitively, this is the 'distance' from the origin that the vector
		// reaches.
		double Magnitude(){
				double xx = x*x;
				double yy = y*y;
				return sqrt(xx + yy);
		}

		// Normalize vector
		// i.e. Convert to a unit vector
		// Note: It doesn't really make sense to normalize a 
		//       integer-based type, so we restrict to floating-point for now.
		// Note: Returns unnormlized vector if length is 0.
		typeof(this) Normalize() {
				// Cache value of magnitude to maybe save some time
				static if(__traits(isFloating,T)){
						if(!isClose(y,0.0)){
								double length = Magnitude();
								x = cast(T)(cast(double)x / length);	
								y = cast(T)(cast(double)y / length);
						}
						return this;
				}else{
						assert(0,"Can only normalize floating point values. Normalize Vec2f, and then cast to Vec2i");
				}
		}


		// Return the slope of the vector
		// If x is zero, return 0.0
		double GetSlope(){
				if(isClose(x,0.0f)){
						return 0.0f;
				}	
				return cast(double)y/cast(double)x;
		}

		// Returns the normal.
		// Note: The returned vector is not normalized.
		// Note: A nice explanation for the 'geometric' interpretation of effectively
		//       rotating the normal is provided.
		//       You may use this source below:
		//       https://stackoverflow.com/questions/1243614/how-do-i-calculate-the-normal-vector-of-a-line-segment
		// Note: A better explanation in point-slope form is  here:
		//       https://math.stackexchange.com/questions/943995/find-a-normal-vector-onto-the-line
		// Note: If a division could result in 0, a 'zero vector' is returned.
		typeof(this) GetNormal(){
				typeof(this) result;
				if(!isClose(y,0.0)){
						result.x =  -y;
						result.y = cast(T)((x));
				}
				return result;
		}
}

// Return the scalar dot product to determine how
// similar two vectors are.
double Dot(T)(T v1, T v2){
		return (v1.x*v2.x) + (v1.y*v2.y);
}

// Reflect a vector across a surface normal.
// 'v' is the incoming (incident) vector
// 'n' is the surface normal of 'v' 
// *Hint* Normalizing the vectors makes this easier
// Helpful chapter: https://immersivemath.com/ila/ch03_dotproduct/ch03.html
// Another pragmatic resource: https://www.sunshine2k.de/articles/coding/vectorreflection/vectorreflection.html
// I used this formula for my implementation at the top:
// https://www.contemporarycalculus.com/dh/Calculus_all/CC11_7_VectorReflections.pdf
T Reflect(T)(T v, T n){
		T result;

		result = v -  (Project(v,n) * 2);

		return result;
}

// Projects vector 'u' onto vector 'v' and returns the
// new vector.
T Project(T)(T u, T v){
		T result;

		double uDotV = u.Dot(v);
		result = v * ((uDotV) / (v.Magnitude()*v.Magnitude()));

		return result;
}


// Alias 'Point2' for the 'Vec2' type.
alias Point2f = Vec2f;
alias Point2i = Vec2i;

// Other functions
double Distance(double x1, double y1, double x2, double y2){
		double xx = x2-x1;
		double yy = y2-y1;
		return sqrt(xx*xx + yy*yy);
}

// Overload of distance with two Point2's
double Distance(T)(T p1, T p2){
		double xx = cast(double)(p2.x - p1.x);
		double yy = cast(double)(p2.y - p1.y);
		return sqrt(xx*xx + yy*yy);
}

float DegreesToRadians(float degree){
		return degree * ( PI / 180.0f);
}
float RadiansToDegrees(float rad){
		return rad * ( 180.0f / PI);
}

// Projection unit test
unittest{
		Vec2f u = Vec2f(4,3);
		Vec2f v = Vec2f(2,8);

		// Project vector u onto vector v
		auto result = Project(u,v);

		writeln(result);
		assert(isClose(result.x, (16.0/17.0)) && isClose(result.y, (64.0/17.0)), "Expected ~.94117 and 3.7647");

}


// Compute the distance between two points 
unittest{
		// Manual point entry
		assert(Distance(3,5, 6,9) == 5, "5 expected"); 
		// Templated function
		assert(Distance(Vec2i(3,5),Vec2i(6,9)) == 5, "5 expected");
		assert(isClose(Distance(Vec2f(3.0f,5.0f),Vec2f(6.0f,9.0f)), 5.0f), "5.0f expected");
		// Testing alias
		assert(Distance(Point2i(3,5),Point2i(6,9)) == 5, "5 expected");
		assert(isClose(Distance(Point2f(3.0f,5.0f),Point2f(6.0f,9.0f)), 5.0f), "5.0f expected");
}

// Degrees and radians conversions
unittest{
		float initial = 47.0f;
		float rads = DegreesToRadians(initial);
		float result = RadiansToDegrees(rads);

		assert(isClose(result,47.0f), "Expected 47.0f");
}


// Test for instantiating different types
unittest{
		auto myVec1 = Vec2!float();
		auto myVec2 = Vec2!double();
		auto myVec4 = Vec2!int();
		auto myVec6 = Vec2!long();

		//  Note: Why are these types not available?
		//        In short, we don't need to support them.
		//        For our vector library otherwise, we need
		//        signed types.
		//auto myVec3 = Vec2!char();
		//auto myVec5 = Vec2!short();
		//auto myVec7 = Vec2!ushort();
		//auto myVec8 = Vec2!uint();
		//auto myVec9 = Vec2!ulong();
}

// Test alias of type
unittest{
		auto myVec1 = Vec2f();
		auto myVec2 = Vec2i();
}

// Test constructors
unittest{
		Vec2!float test0 = Vec2!float(7.4f,9.6f);
		Vec2f test = Vec2f();
		Vec2i test2 = Vec2i(1,2);
}

// Test size of the data type
unittest{
		static assert(float.sizeof == 4, "4 for size of float on this architecture");
		assert(Vec2f.sizeof == float.sizeof*2, "8 expected");
}

// Test data layout within struct
unittest{
		auto myVec1 = Vec2f();

		assert((myVec1.x == myVec1.s) && (myVec1.i == myVec1[0]),"");
		assert((myVec1.y == myVec1.t) && (myVec1.j == myVec1[1]),"");
}

// Negation test
unittest{
		Vec2i v1;
		v1.x = 5;
		v1.y = 6;
		v1 = -v1;

		writeln(v1);
		assert(v1.x == -5, "-5 expected");
		assert(v1.y == -6, "-6 expected");
}

// Test opUnary for ++ and --
// This tests both pre and post-increment and
// pre and post-decrement
unittest{
		Vec2i v1;
		v1.x = 2;
		v1.y = 3;

		v1++;
		assert(v1.x == 3, "3 expected");
		assert(v1.y == 4, "4 expected");
		v1--;
		assert(v1.x == 2, "2 expected");
		assert(v1.y == 3, "3 expected");
		++v1;
		assert(v1.x == 3, "3 expected");
		assert(v1.y == 4, "4 expected");
		--v1;
		assert(v1.x == 2, "2 expected");
		assert(v1.y == 3, "3 expected");
}

// Test opBinary for addition and subtraction of vectors
unittest{
		Vec2i v1;
		Vec2i v2;

		v1.x = 5; v1.y = 7;
		v2.x = 5; v2.y = 7;

		v1 = v1 + v2;
		assert(v1.x ==10 && v1.y == 14, "10 and 14 expected");
		assert(v2.x ==5 && v2.y == 7, "5 and 7 expected");
		v1 = v1 - v2;
		assert(v1.x ==5 && v1.y == 7, "5 and 7 expected");
		v1 = v2 - v1;
		assert(v1.x ==0 && v1.y == 0, "0 and 0 expected");
}

// Test opBinary with opUnary operation
unittest{
		Vec2i v1;
		Vec2i v2;

		v1.x = 5; v1.y = 7;
		v2.x = 5; v2.y = 7;

		v1 = -v1 + -v2;

		assert(v1.x ==-10 && v1.y ==-14, "0 and 0 expected");
}

// Test opBinary with * and / for scalar multiplication and division
unittest{
		Vec2f v1;
		double scalar = 2.0;

		v1.x = 5; v1.y = 7;

		v1 = v1 * scalar;
		writeln(v1);

		assert(v1.x ==10 && v1.y ==14, "10 and 14 expected");
}


// Test opBinary with * and / for scalar multiplication and division
unittest{
		Vec2f v1 = Vec2f(1.5f,2.5f);
		Vec2f result = v1 * 2.0f;

		assert(result.x == 3.0f && result.y == 5.0f, "3.0f and 5.0f expected");
}


// Test opOpAssign for assignment and an operation
unittest{
		Vec2f v1 = Vec2f(1.0,1.0);
		Vec2f v2 = Vec2f(2.0f,2.0);

		v1 += v2;
		v1 -= v2;

		v1 *=5;
		v1 /=5;

		v1 += v2;

		assert(v1.x ==3.0 && v1.y ==3.0, "3 and 3 expected");

		v1 *= 3;

		assert(v1.x ==9.0 && v1.y ==9.0, "9 and 9 expected");
}

// Test magnitude operation
unittest{
		Vec2f v1;
		v1.x = 3.0f;
		v1.y = 4.0f;

		assert(isClose(v1.Magnitude(),5.0), "Expected 5.0 or close");
}

// Test if normalized function is working
unittest{
		Vec2f v1;
		v1.x = 3.0f;
		v1.y = 4.0f;

		v1.Normalize();

		assert(isClose(v1.Magnitude(),1.0,1e-2, 1e-5), "Expected 1.0 or close");
}

// Test if normalized function is working with negatives
unittest{
		Vec2f v1 = Vec2f(-3.0f,-4.0f);

		v1.Normalize();

		assert(isClose(v1.Magnitude(),1.0,1e-2, 1e-5), "Expected 1.0 or close");
}

// Take the dot product of two vectors
unittest{
		Vec2i v1;
		Vec2i v2;

		v1.x = 0;	v1.y = 1;
		v2.x = 1;	v2.y = 0;

		assert(v1.Dot(v2) == 0, "Expected 0.0 or close");

		Vec2f v3;
		Vec2f v4;

		v3.x = -1;	v3.y = 0;
		v4.x = 1;	v4.y = 0;
		assert(v3.Dot(v4) == -1, "Expected -1 or close");
}

// Retrieve the normal
unittest{
		Vec2f v1;
		v1.x = 8;	v1.y = 4;

		Vec2f normal = v1.GetNormal();
		writeln(normal);
		assert(normal.x == -4.0f && normal.y ==8.0f, "");
}


// Take the dot product of two vectors
unittest{
		Vec2f v1;
		v1.x = 8;	v1.y = 4;

		assert(v1.GetSlope()==0.5, "Expected 0.5 or close");
		v1.x = 4;	v1.y = 8;

		assert(v1.GetSlope()==2.0, "Expected 0.5 or close");
}


// GetSlope test
unittest{
		Vec2f v1 = Vec2f(5.0f,1.0f);
		Vec2f v2 = Vec2f(0.0,10.0f);

		assert(v1.GetSlope() == 0.2f,"0.2f expected");
		assert(v2.GetSlope() == 0.0f,"0.0f expected -- infinite slope effectively");
}

// Reflection Test
unittest{
		// Draw some line along x-axis
		Vec2f v1 = Vec2f(2.0,1.0f);
		// Creating an incoming vector
		Vec2f i  = Vec2f(-1.0f,-1.0f);

		auto reflectedVector = Reflect(i,v1.GetNormal());

		writeln("reflectedVector",reflectedVector);
}
