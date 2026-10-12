// @file: template.d
import std.stdio;
// 
// Templates in the D programming language are one of the languages
// superpowers. 
// A 'template' is not real code, but otherwise provides a 'blueprint'
// for code that is generated a compile-time. Templated code goes
// through the normal stages of compilation otherwise, so it is 
// more type-safe than languages like C which rely on the C-preprocesor.
// Let's first take a look at an example of a 'template'.
// 
// A 'template function' in the D programming language uses an additional
// set of parameters. The additional set of template parameters appears
// prior to the function parameteres.
// The example below uses 'T' as a symbol for the template.
//

// Blueprint -- not a real function
// Template
T add(T)(T a, T b){
  return a + b;
}

// In order to use the templated function, we specifiy after
// an '!' mark the template parameters. If we only have one
// parameter, we can omit the parenthesis.
//
//  add!int(7,2);
//  add!(int)(7,2); // Equivalent to the above line.

// When we use a templated function, the compiler will do
// the work for us and generate a version of the function
// with the templated parameters replaced.
// 
// This is what the compiler generates for add!int(7,2);
// Observe that 'T' was substituted with a new symbol.
//int add!(T:int)(int a, int b){
//  return a + b;
//}

// > If you are coming from a language like C++,
// > you may be familiar with the angle brackets (<>'s) that otherwise
// > indicate a template parameter. Templates in D you will find
// > provide a cleaner syntax and quite a bit more flexible!

// D's templates can be applied to structs, classes, or just regular
// blocks of code. This is what is known as a 'mixin template'.
// Below is an example -- though it is a perhaps 'bad' example that
// merely creates a variable named 'myVariable' with the type specified
// by T.
mixin template test(T){
  mixin("T myVariable;");
}

// Below is perhaps a more useful demonstration of a mixin template block.
// This will produce a templated function that prints the .init value.
// The function itself is not templated, but the mixin template block
// will generate a newly named function.
// This also combines a regular 'string mixin' to generate the function

mixin template PrintInit(T){
  mixin(`
      void PrintInit`,T.stringof,`(){
        writeln("`~T.stringof~`.init value=",`,T,`.init);
    }`
  );
}

// Here we can generate the functions from the mixin block.
mixin PrintInit!int;
mixin PrintInit!float;
mixin PrintInit!short;

// To call the functions generated, they will be named:
//  as follows:
//  PrintInitint();
//  PrintInitfloat();
//  PrintInitshort();

// We should backup a bit and also show that a 'mixin' itself, is
// just a piece of D code as a string. What is powerful about 'string mixins' is that you can build strings a compile-time that generate code, as shown with the 'mixin template' example.

// Note: Templates again can be used with classes and structs.
// Observe below an example of a 'FixedArray' type where we can
// specify the type (T) and size (S). Note: This time 'S' is 'typed' 
// such that the second template pararemter must be an 'integer'.
struct FixedArray(T,int S){
  T[S] myArray;
}


void main(){
  
  add!int(7,2);
  add!(int)(7,2);
  // Note: D is smart enough to 'infer' template arguments in many cases.
  //       In this case, the templated functino matches just regular code,
  //       though sometimes you may want to be specific about which instance
  //       you want to use. For example, you might want add!short(7,2) to 
  //       explicitly work with a 2-byte short instead of whatever the
  //       compiler infers.
  add(7,2);

  // These are equivalent lines
  mixin(`writeln("hello");`);
  writeln("hello");

  // Mixin a variable
  mixin test!(int);
  writeln("myVariable=", myVariable, " is from a mixin template");

  // Note: We can omit the parenthesis if we like if there
  // are no parameters.
  PrintInitint;
  PrintInitfloat;
  PrintInitshort;

  // We can use 'writln' to print out the FixedArray template.
  // BUt how did 'writeln' know how to print out our custom
  // datatype? Well -- writeln itself is a template that infers
  // the arguments.
  FixedArray!(int,5) myFixedArray;
  writeln(myFixedArray);
}

// F.A.Q.
// Q: What if I want to just pass in 'anything' into a template parameter?
// A: You can use 'alias' as the 'type' 
// e.g.
//  MyTemplateFunc(alias T)(){}
//
// Q: How can I see what the compiler is doing?
// A: You can try using the '-mixin' or 'vgc-ast' flags to see some
//    of the compiler transformations.
