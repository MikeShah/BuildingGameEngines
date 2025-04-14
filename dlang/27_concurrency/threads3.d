// @file: threads3.d
import std.stdio;
import std.concurrency; // for spawn
import core.thread;		  // for thread_joinAll

shared int global_value=0;

void shared_task(int x){
	global_value=global_value+x;
	writeln("global_value is now: ", global_value);
}

void main(){

	// Launch a new thread
	for(int i=0; i < 100; i++){
		Tid myID = spawn(&shared_task,1);
	}

	// Blocks until all threads that are spawned are completed
	thread_joinAll();

	// Continue on main thread
	writeln("global_value is:",global_value);
	writeln("End of program");
}
