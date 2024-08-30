module gamestate;

import std.stdio;
import std.file;
import std.conv;

///=============================
/// GameState Class for our simple game 
///
/// Note: Our game...is a very linear story for now
///=============================
struct GameState{

    public:
        /// Constructor
        this(string file){
            File myFile = File(file);

            if(myFile.isOpen()){
                foreach(line; myFile.byLine){
                    mStory ~= line.idup;
                }
            }else{
                writeln("unable to open file ",file);
            }

            mChoice =0;
            mCurrentLine=0;

            writeln(mStory[0]);
        }

        /// Destructor
        ~this(){
            writeln("The End\n");
        }

        /// Retrieve the current line (maintain const correctness)
        size_t GetCurrentLine() const{
            return mCurrentLine;
        }

        /// Set the current line in the stor
        void SetCurrentLine(size_t value){

            if(value <0) { 
                mCurrentLine=0; 
            }
            else if(value > mStory.length-1){
                mCurrentLine= mStory.length-1;
            }else{
                mCurrentLine = value;
            }
        }

        /// Print the current line
        void PrintCurrentLine(){
            writeln(mStory[mCurrentLine]);
        }

        /// Set the state of the game
        void SetChoice(int value){
            mChoice = value;
        }

        /// Retrieve the last choice made
        int GetChoice() const{
            return mChoice;
        }

    private:
        int                         mChoice;
        size_t                      mCurrentLine;
        string[]                    mStory;
};

