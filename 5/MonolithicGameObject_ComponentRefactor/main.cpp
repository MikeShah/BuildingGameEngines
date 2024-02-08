// main.cpp
#include "GameObject.hpp"
#include <iostream>

int main(){

    GameObject* Mario = new GameObject();
    TextureComponent* texture = new TextureComponent;
    Mario->AddComponent<TextureComponent>(texture);

    Mario->Update();

    return 0;
}
