/// A module for various geometry functions
module geometry;
import std.math;

/// Helper function 
/// that converts from angle to radians.
float Radians(float angle){
		return angle * (PI / 180);
}

/// Helper function which converts from
/// degrees to radians.
float Degrees(float radians){
		return radians * (180 / PI);
}
