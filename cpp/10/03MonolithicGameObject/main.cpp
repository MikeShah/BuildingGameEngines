// main.cpp
#include "GameObject.hpp"
#include <iostream>

void gameLoop(){
    std::vector<GameObject*> gameObjects;
    /* initialize several game objects */
    // ...
    
    while(true){
        // Handle input
        input();

        // Update (exapanded)
        // Update all of our objects
        for(auto& object : gameObjects){
            object->Update();
        }

        // Render
        render()
    }
}


int main(){

    GameObject* Mario = new GameObject();
    Mario->mTexture = new Texture();

    gameLoop();


    return 0;
}
