// @file: threads5.d
import std.stdio;
import std.concurrency; // for spawn
import core.thread;		  // for thread_joinAll
import core.sync;				// for mutex

shared int global_value=0;
shared Mutex global_mutex;

shared static this(){
	// Initialize the mutex class
	global_mutex = new shared Mutex();
}

void shared_task(int x){
	global_mutex.lock();	
		global_value=global_value+x;
	global_mutex.unlock();
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
	writeln("global_value is: ", global_value);
	writeln("End of program");
}
