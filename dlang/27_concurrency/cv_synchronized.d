// @file: cv_synchronized.d
// Goal: This file shows how to use a condition variable to 'notify' on all threads.
//       Note: Need 'cv' in a while to avoid spurious wakeups on some platforms.
// dmd -g cv.d -of=prog && ./prog
import std.stdio;
import core.thread;
import std.concurrency;
import core.sync;
import std.process;
import core.atomic;

int iterations = 10;  // Number of iterations each thread should perform
shared Mutex mtx;
shared Condition cv;
shared int counter = 0;  // Shared counter to track when all threads should move forward
const int threadCount = 4;  // Number of threads you want to run

shared static this(){
  mtx = new shared Mutex;
  cv = new shared Condition(mtx);
}

void worker(string threadName) {
    // Loop through the specified number of iterations
    for (int i = 0; i < iterations; i++) {
        // Perform some work (can be replaced with actual task)
        writeln("Thread (", threadName, ") working on iteration \t", i);

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
    threads[0] = spawn(&worker,"Physics");
    threads[1] = spawn(&worker,"AI");
    threads[2] = spawn(&worker,"Solver");
    threads[3] = spawn(&worker,"Render");

    thread_joinAll();

    writeln("All threads have finished their work.");
}
