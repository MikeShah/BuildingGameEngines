// @file: compile_time_command.d
// Based on: https://wiki.dlang.org/Compile-time_Command_Pattern
//
// The purpose is perhaps to make the command more 'inlinable'.
// We could also (given a common interface) store functions without
// any 'virtual function' cost, since we have a 'struct' type here.
// From a code analysis standpoint, I think this pattern could also
// be useful for introspection on the arguments, and perhaps recording
// function calls/arguments for loggers.
//

// Allows us to implement the command pattern, but at compile-time
struct Command(alias fun, Args...){
  // Store the variadic arguments (i.e. any number of arguments)
  Args args_;

  // Call the function with the store arguments.
  auto Execute(){
    return fun(args_);
  }
}

// Helper function to make it easy to return our function
// at compile-time
auto command(alias fun, Args...)(Args args){
  return Command!(fun,Args)(args);
}


int sum(int a,int b){
  return a+b;
}

void main(){
  import std.stdio;

  auto cmd = command!((a,b)=>a*b)(3,2);
  assert(cmd.Execute()==6);


  auto AdderExplicit = command!(sum,int,int)(2,7);
  // Note: Types can be inferred, so here is a shorter version
  auto Adder = command!(sum)(2,7);

  writeln(AdderExplicit.Execute);
  writeln(Adder.Execute);

}
