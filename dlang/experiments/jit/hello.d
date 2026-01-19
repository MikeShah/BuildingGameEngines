// This is a neat example showing how to 'embed' a system call into executable memory.
// At the end of the day, we just need to be able to use something like 'mmap' to otherwise
// create an executable region of memory.
// We can then encode various 'system calls' (e.g. 'write' shown here) to then run a string.
// There's a bit of work to do, and this would have to be 'per architectuer' (e.g. x86, ARM, etc.) to
// properly function.
//
// Based off the series:
// Part 1
// 	 https://solarianprogrammer.com/2018/01/10/writing-minimal-x86-64-jit-compiler-cpp/
// Part 2
//	 https://solarianprogrammer.com/2018/01/12/writing-minimal-x86-64-jit-compiler-cpp-part-2/
// Based off code: https://github.com/sol-prog/x86-64-minimal-JIT-compiler-Cpp/blob/master/part_1/hello_3.cpp
/+

I think the part that matters for part 1 here is the following:
This snippet of assembly code is what we compile to be our 'write' syscall.

This is the 'build' for the object file to get the correct op codes from the assembly.
1 as chunk.s -o chunk.o
2 objdump -M intel -D chunk.o

 1 # Enforce Intel syntax
 2 .intel_syntax noprefix
 3 
 4 # Call the "write" system function (man 2 write)
 5 # ssize_t write(int fd, const void *buf, size_t count);
 6 mov rax, 1							# Store the "write" system call number 0x1 for Linux or 0x2000004 for macOS
 7 # Put the function arguments in the rdi, rsi, rdx, r10, r8, r9 registers
 8 mov rdi, 1							# Store where to write stdin which is 0x1 for Linux and macOS
 9 lea rsi, [rip + 0xa]				# Store the location of the string to write (0xa instructions from the current instruction pointer)
10 mov rdx, 17							# Store the length of the string
11 # Call the function
12 syscall
13 ret
14 .string "Hello, Your Name\n"












+/

import std.stdio;
import std.file;

// a 'baked in' write call
ubyte[] write_sys_call(ref string name){

	ubyte[] bytes = [
			0x48,0xc7,0xc0,0x01,0x00,0x00,0x00,//mov rax,0x1
			0x48,0xc7,0xc7,0x01,0x00,0x00,0x00,//mov rdi,0x1
			0x48,0x8d,0x35,0x0a,0x00,0x00,0x00,//lea rsi,[rip+0xa] #,0x1f
																				 // This part is somewhat important,  in which the 'string' in memory
																				 // that we are storing, is '10' (0xa) bytes away.
																				 // This means that the instruction pointer here + 10 bytes away is
																				 // where we'll want to start reading a null-terminated string.
																				 // We load this into the 'rsi' register as otherwise shown, and
																				 // ultimately this will allows us to run our code.
																				 // If the address we refer to is in executable memory 
																				 // (e.g. a string in the D executable code) this is fine, or otheriwse
																				 // if we dynamically put in some address after a successful mmap.
																					
			0x48,0xc7,0xc2,0x11,0x00,0x00,0x00,//mov rdx,0x11
			0x0f,0x05,												 //syscall
			0xc3															 //ret
	];

	// Modify the 'location' of the string with name's address
	bytes[24] = (name.length & 0xFF) >> 0;
	bytes[25] = (name.length & 0xFF00) >> 8;
	bytes[26] = (name.length & 0xFF0000) >> 16;
	bytes[27] = (name.length & 0xFF000000) >> 24;

	return bytes;
}

alias off_t = long;
enum PROT_READ     = 0x1;  /* Page can be read.  */
enum PROT_WRITE    = 0x2;  /* Page can be written.  */
enum PROT_EXEC     = 0x4;  /* Page can be executed.  */
enum PROT_NONE     = 0x0;  /* Page can not be accessed.  */
enum MAP_SHARED    = 0x01; /* Share changes.  */
enum MAP_PRIVATE   = 0x02; /* Changes are private.  */
enum MAP_ANONYMOUS = 0x20; /* Don't use a file.  */
extern(C) void *mmap(void* addr, size_t length, int prot, int flags, int fd, off_t offset);


void main(){
  string name;
  writeln("What is your name");
  name = readln();
	string welcome = "welcome "~name;
//  writeln("Hello: ", name);

 // std.file.write(deleteme,name);
	ubyte[] jit_bytes= write_sys_call(welcome);

	// Append some bytes
	foreach(c ; welcome){
		jit_bytes ~= c;
	}


	// Allocate some 'executable memory' using mmap
	import std.mmfile;	
	// TODO: Just use '4096' as 'big-enough'
	ubyte* executable_memory = cast(ubyte*)mmap(null, 4096, PROT_READ | PROT_WRITE | PROT_EXEC, MAP_PRIVATE | MAP_ANONYMOUS ,-1, 0);

	// Copy generated machine code to the
	for(int i=0; i < jit_bytes.length;i++){
		executable_memory[i] = jit_bytes[i];
	//	writef("%X ",cast(int)executable_memory[i]);
	}
//	writeln;

	// Create a callable 'function'
	void function() run_machine_code;
	run_machine_code = cast(void function())executable_memory;
	run_machine_code();

	// Debug the bytes we tried to execute
	dumpBytes(jit_bytes);

	// Unmap the executable memory
	// TODO

}

void dumpBytes(ubyte[] mem){
	writeln("=================================");
	int counter=0;
	for(int i=0; i < mem.length;i++){
		writef("%X(%c)\t",cast(int)mem[i],cast(char)mem[i]);
		counter++;
		if(counter==7){
		 writeln;
		 counter=0;
		}
	}
	writeln;
	writeln("=================================");
}
