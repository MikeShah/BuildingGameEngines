#include "GameState.hpp"
#include <iostream>

GameState::GameState(std::string file){
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
