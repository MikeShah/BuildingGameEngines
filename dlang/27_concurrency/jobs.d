// @file: jobs.d
// Goal: Show how to send jobs to a worker thread. 
// dmd -g jobs.d -of=prog && ./prog
import std.stdio;
import core.thread;
import std.concurrency;
import core.sync;
import std.process;
import core.atomic;
import std.datetime.stopwatch;

int iterations = 10;  // Number of iterations each thread should perform
shared Mutex mtx;
shared Condition cv;
shared int counter = 0;  // Shared counter to track when all threads should move forward
const int threadCount = 4;  // Number of threads you want to run

shared static this(){
  mtx = new shared Mutex;
  cv = new shared Condition(mtx);
}

// Jobs can be loaded up 'per thread'
void Job(string N)(string name){
	int thinkingIterations = 0;
	while(thinkingIterations < 4){
		writeln("\tRunning step #",thinkingIterations," of (",name,") in (",N,")");
		thinkingIterations++;
    Fiber.yield();
	}
  return;
}

// Each thread now has some number of 'fibers' associated with it.
void worker(string N)(string threadName, int jobStart, int jobEnd) {

    // Collect the fibers somewhere
    Fiber fib1 = new Fiber(()=>Job!N("unique fiber 1"));
    Fiber fib2 = new Fiber(()=>Job!N("unique fiber 2"));
    Fiber[] fibersAsJobs;
    fibersAsJobs ~= fib1;
    fibersAsJobs ~= fib2;

    // Loop through the specified number of iterations
    for (int i = 0; i < iterations; i++) {
        // Perform some work (can be replaced with actual task)
        writeln("Thread (", threadName, ") working on iteration \t", i);

        // Start doing some work
        foreach(job ; fibersAsJobs ){
          if(job.state != Fiber.State.TERM){
           job.call();
          }
        }

        // Increment the counter (each thread does this independently)
        synchronized(mtx) {
            counter.atomicOp!"+="(1);
            if (counter == threadCount) {  // Check if all threads have completed the iteration
                counter.atomicStore(0); // Reset the counter
                cv.notifyAll();  // Notify all threads to proceed to the next iteration
                writeln("--------------");
            } else {
                cv.wait();  // Wait for other threads to complete the iteration
            }
        }
    }
}

void main() {
    // Create the threads
    Tid[threadCount] threads;;

    threads[0] = spawn(&worker!"physics","Physics",0,2);
    threads[1] = spawn(&worker!"ai","AI"     ,2,4);
    threads[2] = spawn(&worker!"solver","Solver" ,4,6);
    threads[3] = spawn(&worker!"render","Render" ,6,8);

    thread_joinAll();

    writeln("All threads have finished their work.");
}
