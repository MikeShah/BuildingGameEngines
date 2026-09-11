// For baremetal programming you may occassionally want a non 'main function' start symbol.
// You can redfine this symbol. I was able to get this to work with ldc2 (and probably gdc)
// by passing flags to the linker (Everything after '-L') for the 'mymain' symbol.
//
// ldc2 -L-Wl,-e,mymain -betterC nonmain_start.d -of=prog && ./prog
//
//import std.stdio; // Not allowed in betterC mode because of exceptions.
//
import core.stdc.stdio;
import core.stdc.stdlib;

pragma(startaddress, mymain);
extern(C) void mymain(string[] args){
  core.stdc.stdio.printf("Call mymain first before main\n");
  // Call our function
  main();
}

extern(C) void main(){
  core.stdc.stdio.printf("D Lang main\n");

  // We need some sort of 'exit status' -- I just return '0'.
  exit(0);
}
