// @file: threads1.d
import std.stdio;
import std.concurrency; // for spawn
import core.thread;		  // for thread_joinAll

void test(int x){
	writeln("Hello from thread! printing: ",x);
}

void main(){

	// Launch a new thread
	Tid myID = spawn(&test,144);

	// Blocks until all threads that are spawned are completed
	thread_joinAll();

	// Continue on main thread
	writeln("End of program");

}
