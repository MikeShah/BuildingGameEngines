// @file filewatcher.d
import std.stdio;
import std.file;
import std.datetime;
import core.thread;

struct FileWatcher{
	
	this(string filepath){
		if(filepath.exists){
			assert(filepath.isFile,"FileWatcher currently only watches files and not directories");
			mFilepath = filepath;
			mStartTime = Clock.currTime();	
			writefln("Started watching %s at %s",mFilepath,mStartTime);
		}else{
			assert(0, "Attempting to watch a file that does not exist.");
		}
	}
	// Pass in a callback for what to do when
	// a file changes.
	void SetCallbackOnChange(void function(string) callback){
		mCallback = callback;
	}

	void OnChange(string arg){
		if(mFilepath.exists){
				// NOTE: You will have to find a way to 'poll' this function
				//       otherwise if you write to a file, we may not be able
				//       to 'stat' the file and get its modification attributes.
				//       Thus, you may get an exception, and need to otherwise 
				//       handle the exception.
				Thread.sleep(200.msecs);

				DirEntry d = DirEntry(mFilepath);
				SysTime currentTime= d.timeLastModified;
				if(currentTime > mStartTime){
					// Update time
					mStartTime = currentTime;
					// Perform callback
					mCallback(arg);
				}
		}
	}
	string mFilepath;
	SysTime mStartTime;
	void function(string) mCallback;

}

void log(string arg){
	writeln(arg);
}

void main(){
	FileWatcher f = FileWatcher("./data.txt");
	f.SetCallbackOnChange(&log);
	// At some point, try to change or save
	// the file 'data.txt'
	while(true){
		f.OnChange("log or do something interesting");
	}
}
