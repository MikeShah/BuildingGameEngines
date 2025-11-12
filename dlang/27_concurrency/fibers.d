// @file: fibers.d
// Goal of this code is to show how you can have an algorithm or system run
// for some 'number of timesteps' using fibers to otherwise control the game
// systems.
import std.stdio;
import core.thread;		  // for Fibers
import std.datetime.stopwatch;

// Idea behind
void System(string name){
	auto thinkTime = StopWatch(AutoStart.yes);
	int thinkingIterations = 0;

	while(true){
		writeln("Executing step #",thinkingIterations," of ",name," system");
		thinkingIterations++;
		// Yield our state after some number of units of time
		if(thinkTime.peek().total!"msecs" > 1000){
			Fiber.yield();
			// Restart the timer
			thinkTime.reset();
			thinkTime.start();
			thinkingIterations=0;
		}
	}
}

void main(){
	// Note: Parameter into the Fiber for construction here has been setup
	//       as a delegate to call with the parameters.
	// 		 Thus the '()=> some_function(args...)' syntax.
	Fiber enemyFiber = new Fiber(()=>System("enemy logic"));
	Fiber worldFiber = new Fiber(()=>System("world logic"));
	// Collect the fibers somewhere
	Fiber[] fibers = [enemyFiber,worldFiber];
	// Run all of the fibers
	while(true){
		foreach(system ; fibers){
			system.call();
		}
	}
}
