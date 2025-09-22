// @file async.d
import std.stdio;
import std.parallelism;
import core.thread;
int asyncRead(string filename){
    writefln("\t\t\tStarting async read: %s", filename);

    Thread.sleep(2.seconds);
    writefln("\t\t\tCompleted %s read", filename);

    return 147;
}

void main(){

    // (1) Task creation
	writeln("\t\t\tLaunching async task in main thread");
    auto myTask= task!asyncRead("data.txt");
    // (2) Task started
    myTask.executeInNewThread();

    // ---------------------------------------
    // Do some other task while 'myTask'
    // completes its work concurrently.
    writeln("Resuming main thread: ");
    for(int i=0; i < 10; i++){
        Thread.sleep(50.msecs);
        write(i," in main thread\n");
        stdout.flush();
    }   
    writeln();
    // --------------------------------------
    // (3) Task awaited for
	writeln("Awaiting async task in main thread");
    immutable taskResult = myTask.yieldForce();
    writeln();
    writeln("Finished Task: ", taskResult);
    writeln("Finished main");
}
