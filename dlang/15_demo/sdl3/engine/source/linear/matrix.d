// @file: matrix.d
import std.math;
import vec2;
import vec3;
import geometry;

// Matrix3x3 
struct mat3
{
    // Note: enum's here are not needed, but it helps document memory layout
    // of rows, and then columns in the multidimensional array.
    enum ROW = 3;
    enum COL = 3;
    // Initialize always with identity matrix unless otherwise specified
    float[ROW][COL] e = [[1.0f, 0.0f, 0.0f],
    [0.0f, 1.0f, 0.0f],
    [0.0f, 0.0f, 1.0f]];

    // Sets every value to a specific value
    // This is handy to 'zero' a matrix for instance
    this(float value)
    {
        e = value;
    }

    // Construct each element
    // e10 - means row 1, column 0
    this(float e00, float e01, float e02,
            float e10, float e11, float e12,
            float e20, float e21, float e22)
    {
        e[0][0] = e00;		e[0][1] = e01;		e[0][2] = e02;
        e[1][0] = e10;		e[1][1] = e11;		e[1][2] = e12;
        e[2][0] = e20;		e[2][1] = e21;		e[2][2] = e22;
    }

    // Assign value to multidimenstional array
    void opIndexAssign(float value, size_t row, size_t col){
        e[row][col] = value;
    }


    float opIndex(size_t row, size_t col){
        return e[row][col];
    }

    // Index to get the column
    float[3] opIndex(size_t col)
    {
        if(col==0){
            return [e[0][0],e[1][0],e[2][0]];
        }else	if(col==1){
            return [e[0][1],e[1][1],e[2][1]];
        }else{
            return [e[0][2],e[1][2],e[2][2]];
        }
    }

    // Matrix Multiplication
    mat3 opBinary(string op)(mat3 rhs)
    {
        mat3 result = mat3(0.0f);
        static if(op=="*"){
            for(int r= 0; r < 3; r++){
                for(int c=0; c < 3; c++){
                    Vec3 v = cast(Vec3)e[r];
                    Vec3 v2 = cast(Vec3)rhs[c];
                    // Sum up dot products of row and column
                    result.e[r][c] += Dot3(v,v2);
                }
            }
        }
        return result;
    }

    // Handy function to print each row
    // of a matrix one after the other
    void Print()
    {
        import std.stdio;
        writeln("row 0:",e[0]);
        writeln("row 1:",e[1]);
        writeln("row 2:",e[2]);
    }

}

/// Helper function to generate a Translation matrix
mat3 MakeTranslate(float xt, float yt)
{
    mat3 result = mat3(	1.0f,0.0f,xt,
            0.0f,1.0f,yt,
            0.0f,0.0f,1.0f);
    return result;	
}

/// Helper function to generate a scale matrix
mat3 MakeScale(float sx, float sy)
{
    mat3 result = mat3(	sx  ,0.0f,0.0f,
            0.0f,  sy,0.0f,
            0.0f,0.0f,1.0f);
    return result;	
}

/// Makes  rotation.
/// Need to provide in radians
mat3 MakeRotate(float angle_in_radians)
{
    import std.math;

    // Nice optimization to only compute sin/cos one time
    float c = cos(angle_in_radians);
    float s = sin(angle_in_radians);

    mat3 result = mat3(	c   ,  -s,0.0f,
            s   ,   c,0.0f,
            0.0f,0.0f,1.0f);
    return result;	
}

// Retrieve the position of the x and y
// translation values.
Vec2f Frommat3GetTranslation(mat3 m)
{
    Vec2f result = Vec2f(0,0);
    result.x = m.e[0][2];
    result.y = m.e[1][2];
    return result;
}

// How to extract angle from rotation matrix
// https://zpl.fi/converting-rotation-matrices-to-angles/
float Frommat3GetRotation(mat3 m)
{
    // Pick an axis, and see how much it's offset
    Vec2f col0 = Vec2f(m.e[0][0],m.e[0][1]);
    return atan2(col0.y, col0.x);				
}

// The 'scale' of x and y axis is the 'length' of each axis
Vec2f Frommat3GetScale(mat3 m)
{
    Vec2f xAxis = Vec2f(0,0);
    xAxis.x = m.e[0][0];
    xAxis.y = m.e[1][0];

    Vec2f yAxis = Vec2f(0,0);
    yAxis.x = m.e[0][1];
    yAxis.y = m.e[1][1]; 

    Vec2f result;
    result.x = sqrt(xAxis.x * xAxis.x + xAxis.y * xAxis.y);
    result.y = sqrt(yAxis.x * yAxis.x + yAxis.y * yAxis.y);

    return result;
}

/// Helper function for performing translation
/// on a transform object.
/// Returns a transform, so that we can compose transformations
/// easily using Universal Function Call Syntax (UFCS)
mat3 Translate(mat3 m, float x, float y)
{
    m = MakeTranslate(x,y);
    return m;
}

// Perform a rotation
mat3 Rotate(mat3 m, float angle)
{
    m = MakeRotate(angle);
    return m;
}

// Perform a scale
mat3 Scale(mat3 m, float sx, float sy)
{
    m = MakeScale(sx,sy);
    return m;
}

unittest{
    import std.stdio;
    mat3 identity;
    // Access each row
    writeln("col 0:",identity[0]);
    writeln("col 1:",identity[1]);
    writeln("col 2:",identity[2]);
    writeln;
    writeln("row 0:",identity.e[0]);
    writeln("row 1:",identity.e[1]);
    writeln("row 2:",identity.e[2]);

    writeln;

    mat3 m = mat3(1,2,3,4,5,6,7,8,9);
    // Access each row
    writeln("col 0:",m[0]);
    writeln("col 1:",m[1]);
    writeln("col 2:",m[2]);
    writeln;
    writeln("row 0:",m.e[0]);
    writeln("row 1:",m.e[1]);
    writeln("row 2:",m.e[2]);

    // Construct a new translation matrix
    mat3 transform1 = MakeTranslate(10,10);
    // apply a rotation operation
    //		transform1 = transform1 * Rotate(45.0f) * Scale(2.0f,2.0f) * Translate(5.0f,5.0f);

    mat3 transform2 = MakeTranslate(10,10);
    // apply a rotation operation
    //	transform2 = transform2 * Scale(2.0f,2.0f) * Translate(5.0f,5.0f) * Rotate(45.0f);

    writeln(transform1);
    writeln(transform2);
}


unittest{
    import std.stdio;
    // Always default initialized to identity matrix
    mat3 matrix;

    // Top-Left
    matrix.e[0][0] = 7;;
    // 1st row, 0th column
    matrix.e[1][0] = 42;;
    // 1st row, 2nd column
    matrix.e[1][2] = 100;;

    // Print matrix out as we are use to it
    matrix.Print();
    // Visualize flat matrix in memory
    writeln(matrix.e);
    // Test access to matrix

    // Create matching matrix to above with other constructor
    mat3 match = mat3(7,0,0,42,1,100,0,0,1);
    match.Print();	
    writeln(match.e);
}


// Test Translation make functioin
unittest{
    import std.stdio;
    writeln(" ======= Translate test ===== ");
    mat3 mat = MakeTranslate(7,5);
    mat.Print();
}

// Make sure correct rows/columns are set
unittest{
    import std.stdio;
    writeln(" ======= Translate test ===== ");
    mat3 mat;
    mat = mat * MakeTranslate(7,5);
    mat.Print();
}

// Matrix multiplciation
unittest {
    import std.stdio;
    writeln(" ======= mat3 multiply test ===== ");
    mat3 mat1 = mat3(1,2,3,
            4,5,6,
            7,8,9);
    mat3 mat2 = mat3(1,2,1,
            2,4,6,
            7,2,5);

    mat3 result = mat3(0.0f);
    result =  mat1 * mat2;
    result.Print();
}
