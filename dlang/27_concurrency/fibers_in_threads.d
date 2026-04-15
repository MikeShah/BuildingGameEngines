// @file: fibers_in_threads.d
import std.stdio;
import core.thread;		  // for Fibers
import std.concurrency; // For threads.
import std.datetime.stopwatch;

// A job is something that lasts for some duration
void Job(string name){
	auto thinkTime = StopWatch(AutoStart.yes);
	int thinkingIterations = 0;

	while(thinkingIterations < 10000){
		writeln("Executing step #",thinkingIterations," of ",name," system");
		thinkingIterations++;
		// Yield our state after some number of units of time
		if(thinkTime.peek().total!"msecs" > 1000){
			Fiber.yield();
			// Restart the timer
			thinkTime.reset();
			thinkTime.start();
		}
	}
}


void PhysicsUpdate(){
  while(true){
    writeln("2 - Physics update");
    Thread.sleep(1.seconds);
  }
}

void AIUpdate(){
  while(true){
    writeln("3 - AI update");
    Thread.sleep(1.seconds);
  }
}


void main(){
	// Note: Parameter into the Fiber for construction here has been setup
	//       as a delegate to call with the parameters.
	// 		 Thus the '()=> some_function(args...)' syntax.
	Fiber enemyFiber = new Fiber(()=>Job("physics thread logic"));
	Fiber worldFiber = new Fiber(()=>Job(" logic"));


	// Collect the fibers somewhere
	Fiber[] fibers = [enemyFiber,worldFiber];
  foreach(system ; fibers){
    //system.call();
  }

  Tid physics = spawn(&PhysicsUpdate);
  Tid ai      = spawn(&AIUpdate);
	// Run all of the fibers
	while(true){
      writeln("1 - main loop input/render");
      Thread.sleep(1.seconds);
	}

  thread_joinAll();

}
