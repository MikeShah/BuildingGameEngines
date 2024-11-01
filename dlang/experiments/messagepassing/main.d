// This example is using D's built-in message passing.
// While message passing is not necessary, it can make things quite easy.
//
// Useful thread on spawn: https://forum.dlang.org/post/rwijjieabuuirzdqbcnp@forum.dlang.org
// Useful article on event systems: https://www.gamedev.net/articles/programming/general-and-gameplay-programming/effective-event-handling-in-c-r2459/
// https://medium.com/@savas/nomad-game-engine-part-7-the-event-system-45a809ccb68f

import std.stdio;
import std.concurrency;
import std.datetime;
import core.thread;

interface IEvent{
	
}	

struct GameEntity{
}

struct EventCollision{
	this(GameEntity a, GameEntity b){
	}	
}


void CollisionSystemFunc(Tid parentTid){

	bool shutdown = false;

	while(!shutdown){
			receive(
				(EventCollision e){
					writeln("Collision event received:",e);
				}
			);
	}

}

void main(){	

	GameEntity a;
	GameEntity b;

	Tid mainID = thisTid;
	auto thread1 = spawn(&CollisionSystemFunc,mainID);

	// 'Send' some events using message passing
	for(int i=0; i < 10; i++){
		writeln("Waiting for event");
		Thread.sleep(dur!"msecs"(250));
		send(thread1,EventCollision(a,b));
	}

	// Effectively block here until all of our systems finish
	thread_joinAll();
}
