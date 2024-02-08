// MonolithicGameObject_ComponentRefactor/GameObject.hpp
#pragma once
#include <atomic>
#include <vector>
#include <iostream>
#include <map>
// Here are our list of components

enum class ComponentType{TEXTURE,COLLISION,AI,ETC};

struct Component {
    // Every component has a unique type
    ComponentType Type;

    virtual void Update() {}
    virtual ComponentType GetType(){
        return Type;
    }
};

struct TextureComponent : public Component {
    // Set component types
    TextureComponent(){
        Type = ComponentType::TEXTURE;
    }
    void Update() override{
        std::cout << "TextureComponent::Update()\n";
    }
    
    private:
    /* Texture data */
    uint32_t mWidth, mHeight;
};

struct CollisionBoxComponent : public Component {};
struct TransformComponent : public Component {};
struct StateComponent : public Component {};
struct InputComponent : public Component {};
struct UserInterface2DComponent : public Component {};
struct AIBehaviorComponent : public Component {};

/// Game Object Base Type
struct GameObject{
    /// Constructor
    GameObject(){
        // Assign a unique ID to our atomic counter
        mID = sID++;
    }

    /// Destructor
    virtual ~GameObject(){}

    /// Retrieve a unique ID
    uint64_t GetID() const{
        return mID; 
    }

    void AI(){
        if(mComponents.contains(ComponentType::AI)){
            mComponents[ComponentType::AI]->Update();
        }
    }

    void Update(){
        if(mComponents.contains(ComponentType::COLLISION)){
            mComponents[ComponentType::COLLISION]->Update();
        }
    }

    void Render(){
        if(mComponents.contains(ComponentType::TEXTURE)){
            mComponents[ComponentType::TEXTURE]->Update();
        }
    }

    template<typename T>
    void AddComponent(T* c){
        // Insert or update the component
        mComponents[c->GetType()] =c;
    }

    template<typename T>
    T GetComponent(ComponentType type){
        auto found = mComponents.find(type);
        if(found != mComponents.end()){
            return static_cast<T>(found->second);
        }

        return nullptr;
    }

    public:
    /// GameObject Components
    std::map<ComponentType,Component*> mComponents;
    /// Unique ID per Game Object
    uint64_t mID;
    /// For demonstration, we have an atomic counter
    /// that can assign unique ID's to the mID.
    inline static std::atomic<uint64_t> sID{0};
};
