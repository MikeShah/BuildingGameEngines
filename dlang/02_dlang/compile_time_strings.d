/// @file compile_time_strings.d
import std.stdio;
import std.algorithm;

void main(){
    /// Array of integers
    /// I randomly hit numbers on my keywrod
    auto array = [9,3,2,1,3,5,6,2,23,5,6,2,34,3,6,326,23,23,1,5,125,6,235,2,12,02,5];
    
    sort!("a>b")(array);
    writeln(array);

}
