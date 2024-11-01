// Tiny experiment with worker threads and eventually abstarting everything
// to a 'job' that executes with 'fibers' in the context of each thread.

// TODO: Wrap around queue or abstrat it to RingBuffer data structure
// TODO:
//       Lock OS threads to CPUs to avoid context switches and 
//       false sharing issues in L1/L2 cache.
import std.stdio;
import std.concurrency;
import core.thread;


SharedJobQueue gQueue;
// A queue consists of jobs
// Can template this later with a 'Priority' later on
shared struct SharedJobQueue{

    void AddJob(Job j){
        synchronized{
            mJobs[tail] = cast(shared )j; // Cast away shared
            mJobs[tail].message = j.message;
            writeln("\tAdding job:",j, " #",tail);
            tail = tail+1;
        }
    }

    Job GetJob(){
        shared current = head;
        synchronized{
            if(head > tail){
                return Job("empty");
            }
            head = head+1;
            writeln("\tRetrieving job #",current," - ",mJobs[current]);
        }
            return cast(Job)mJobs[current];
    }

    // Ring buffer
    shared head = 0;
    shared tail = 0;

    Job[160] mJobs;
}

struct Job{

    this(string msg){
        message = msg;
    }
    string message;
    Fiber fiber;
}

// Works that process jobs from a shared job queue
void JobThread(){
    import std.datetime;
    writeln("WorkerThread Created:",Thread.getThis().id);
    while(true){
            Thread.sleep(dur!"msecs"(1000));
            Job j = gQueue.GetJob();
            writeln("JobThread - Processing job:", j.message);
    }

    writeln("WorkerThread Ended");
}

// Works that process jobs from a shared job queue
void JobGiverThread(){
    import std.datetime;
    writeln("WorkerThread Created:",Thread.getThis().id);
    while(true){
            Thread.sleep(dur!"msecs"(2000));
            writeln("Job Giver Thread creating job");
            gQueue.AddJob(Job("test"));
    }

    writeln("WorkerThread Ended");
}


void main(){
    writeln("Main thread started");

    auto t1 = new Thread(&JobThread).start();
    auto t2 = new Thread(&JobGiverThread).start();

    // Join my threads and block the main thread
    t1.join();
    t2.join();

    writeln("Main thread ended");
}
