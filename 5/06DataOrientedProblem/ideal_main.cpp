// main.cpp
#include "GameObject.hpp"
#include <iostream>

int main(){

    // Create a Game Object
    GameObject* obj1= new GameObject();
    GameObject* obj2= new GameObject();
    GameObject* obj3= new GameObject();
    GameObject* obj4= new GameObject();

    // Create components
    TextureComponent* tex1 = new TextureComponent;
    TextureComponent* tex2 = new TextureComponent;
    TextureComponent* tex3 = new TextureComponent;
    TextureComponent* tex4 = new TextureComponent;
    
    /* More Components here */
    // .....

    // Add the component
    obj1->AddComponent(tex1);
    obj2->AddComponent(tex2);
    obj3->AddComponent(tex3);
    obj4->AddComponent(tex4);

    // Push all of our objects into some data structure
    std::vector<GameObject*> objects;
    objects.push_back(obj1);
    objects.push_back(obj2);
    objects.push_back(obj3);
    objects.push_back(obj4);

    // Artificial Intelligence
    for(int i=0; i < numberOfEntities; ++i){
        aiComponents[i].update();
    }

    // Collisions/Physics Simulation
    for(int i=0; i < numberOfEntities; ++i){
        colliderComponents[i].update();
    }

    // Rendering
    for(int i=0; i < numberOfEntities; ++i){
        renderComponents[i].render();
    }

    return 0;
}
