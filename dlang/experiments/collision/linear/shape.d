module linear.shape;

import linear;

// Just define a point as 
// a vec2.
struct Point{
	vec2 v;
	alias v this;
}

struct Ray{
	vec2 origin;
	vec2 direction;
}

struct LineSegment{
	vec2 p1;
	vec2 p2;
}

struct Circle{
	vec2 center;
	float radius;
}

struct Rectangle{
	vec2 corner;	// top-left corner
	vec2 size; // width and height or the dimensions of the Rectangle
}

struct OrientedRectangle{
	vec2 center;
	vec2 halfExtend;	
	float rotation;
}
