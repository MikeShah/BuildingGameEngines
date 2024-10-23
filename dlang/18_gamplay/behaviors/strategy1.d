// @file behaviors/strategy1.d
struct Aliens{
	// Reimplement component system here...
}

struct MainPlayer{
	// Reimplement component system here...
}


mixin template ComponentSystem(T){
	T data;
	void GetComponent(/*...*/){
		// ...
	}
	void SetComponent(/*...*/){
		// ...
	}
}

struct AliensGameObject{
	// Reimplement component system here...
	mixin ComponentSystem!(int);
}

struct MainPlayerGameObject{
	// Reimplement component system here...
	mixin ComponentSystem!(int);
}

void main(){
}
