#include <iostream>
#include <string>

class class1{
public:
	std::string name;
	class1(std::string s){
		name=s;
		std::cout << name << " constructor called\n";
	}
	
	~class1(){
		std::cout << name << " destructor called\n";
	}

};


// Initialize some subsystems here
class1 mySystem1("Graphics Subsystem");
class1 mySystem2("Physics Subsystem");
class1 mySystem3("Audio Subsystem");
class1 mySystem4("Collision Subsystem");

int main(){

	return 0;
}












