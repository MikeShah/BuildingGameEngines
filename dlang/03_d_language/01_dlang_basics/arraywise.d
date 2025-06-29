// @file: arraywise.d


void main(){

  import std.stdio, std.algorithm;

  auto a = [1,2,3];
  auto b = [4,5,6];

  int[] products = [0,0,0]; 
  products[] = a[] * b[];
  writeln("array-wise operation: ", products);
  writeln("dot product is: ", products.sum);

  // Same example, but with fixed-size array
  int[3] products2; // Fixed-size array
  products2 = a[] * b[];
  writeln("array-wise operation: ", products2);
  writeln("dot product is: ", products2[0 .. $].sum); // Need slice here for 'sum'

}

