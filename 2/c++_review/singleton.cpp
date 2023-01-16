// Provided is a sample singleton class
// Compile with: g++ -std=c++11 singleton.cpp -o singleton
// Run with: ./singleton

#include <iostream>

class GameEngineFileManager{
	public:
	
	static GameEngineFileManager& instance(){
		static GameEngineFileManager *m_instance = new GameEngineFileManager();
		// Let's print the address of our object to ensure it is the same
		std::cout << "Operating through same old object at address: " << & m_instance << "\n";
		
		// Return an instance to an object, through which we operate from.
		return *m_instance;
	}
	
	// Destructor
	~GameEngineFileManager(){
		// Do any destruction.
		// We probably want to do this more explicitly in another function however
		// (e.g. call it 'shutdown' or 'destory' and call that method.
	}
	
	// Create a regular member function, and operate on it through our instance
	void loadFile(){
		std::cout << "load a file from our GameEngineFileManager\n";
	}
	
	private:
	
	// A private constructor prevents instancing of this object.
	GameEngineFileManager(){
		// Could do some initialization stuff here if we wanted.
		// We should declare it however, to make sure the compiler does
		// not give us a default one.
	}

	// Our actual instance of this class.
	static GameEngineFileManager* m_instance;
	
};

int main(int argc, char** argv){
	
	// Observe how many times the same GameEngineFileManager is used
	// *hint* should be every time!
	GameEngineFileManager::instance().loadFile();
	GameEngineFileManager::instance().loadFile();
	GameEngineFileManager::instance().loadFile();
	GameEngineFileManager::instance().loadFile();
	
	return 0;
}