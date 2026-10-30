// @file: action.d
import std.stdio;

// Interface for actions
abstract class IAction{
	void RunAction();

	string mActionName="unnamed"; // User-defined 'action name'
	bool mIsBlocking=false;
	bool mIsFinished=false;	
}

// Note: We could probably implement these with fibers
//       but I'll use 'bools' for simplicity.
class OneTimeAction : IAction{

	this(string name){
		mActionName = name;
		mIsBlocking=true;
	}

	override void RunAction(){
		writeln("\t\tRunning: ", mActionName);
		mIsFinished = true;
	}
}

class ExpiringAction : IAction{

	this(string name){
		mActionName = name;
		mIsBlocking=true;
	}

	override void RunAction(){
		writeln("\t\tRunning: ", mActionName);
		mIsFinished = true;
	}

	// Add a timer that expires over time
}

class RepeatingAction : IAction{

	this(string name, int steps=0){
		mActionName = name;
		mIsBlocking=true;
		mSteps=steps;
	}

	override void RunAction(){
		writeln("\t\tRunning: ", mActionName);

		// Check if we are done
		if(mSteps==0){
			mIsFinished= true;
		}

		// Perform more of the algorithm...
		mSteps--;
	}

	int mSteps=0;
}
