#ifndef GAMESTATE_HPP
#define GAMESTATE_HPP

#include <vector>
#include <string>
#include <fstream>

///=============================
/// GameState Class for our simple game 
///
/// Note: Our game...is a very linear story for now
///=============================
class GameState{

public:
    /// Constructor
    GameState(std::string file){
        std::ifstream myFile(file.c_str());
        std::string line;

        if(myFile.is_open()){
            while(getline(myFile,line)){
                mStory.push_back(line);
            }
        }else{
            std::cout << "unable to open file " << file << std::endl;
        }

        mChoice =0;
        mCurrentLine=0;

        std::cout << mStory[0] << std::endl;
    }

    /// Destructor
    ~GameState(){
        std::cout << "The End\n";
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
        else if(value > mStory.size()-1){
            mCurrentLine= mStory.size()-1;
        }else{
            mCurrentLine = value;
        }

    }

    /// Print the current line
    void PrintCurrentLine(){
        std::cout << mStory[mCurrentLine] << std::endl;
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
    std::vector<std::string>    mStory;
};

#endif
