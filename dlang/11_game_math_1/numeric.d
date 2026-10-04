// @numeric.d
// Some samples with D's numeric library for 
// doing some vector operations with built-in library functions.
import std.stdio, std.numeric;
import std.math;

void main(){
  float[] a=[1,2];
  float[] b=[0,2];
  float[] c=[2,0];

  dotProduct(a,b).writeln;
  cosineSimilarity(a,b).writeln;
  (57.295779*acos(cosineSimilarity(a,b))).writeln;
  (57.295779*acos(cosineSimilarity(b,c))).writeln;
  euclideanDistance(a,b).writeln;
  euclideanDistance(b,c).writeln;

}
