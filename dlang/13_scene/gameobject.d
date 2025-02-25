// @file gameobject.d
import std.stdio;

struct GameObject(bool Debug=false){

	static if(true == Debug){
		string log;	
	}
	
	uint mID;

	void DoSomething(){
		static if(Debug){
			writeln("doSomething() called for ",cast(void*)&this);
		}
	}
}


void main(){
	// Game object with extra information
	auto go1 = GameObject!(true)();
	auto go2 = GameObject!(false)();

	go1.DoSomething();
	go2.DoSomething();
}

