// main.cpp
#include "GameObject.hpp"
#include <iostream>

int main(){

    // Create a Game Object
    GameObject* Mario = new GameObject();
    // Create a Component
    TextureComponent* texture = new TextureComponent;
    // Add the component
    Mario->AddComponent(texture);

    /* ... */

    // In our game-loop, update all of our game objects
    Mario->Update();

    texture = Mario->GetComponentAtIndex<TextureComponent*>(0);

    return 0;
}
