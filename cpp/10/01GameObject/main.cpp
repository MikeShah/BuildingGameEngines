// main.cpp
#include "GameObject.hpp"
#include <iostream>

int main(){

    GameObject* Mario = new GameObject();
    GameObject* Mario2 = new GameObject();
    std::cout << Mario->GetID() << std::endl;
    std::cout << Mario2->GetID() << std::endl;

    return 0;
}
