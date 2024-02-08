// MonolithicGameObject_ComponentRefactor/GameObject.hpp
#pragma once
#include <atomic>
#include <vector>
#include <iostream>
// Here are our list of components

struct Component {
    virtual void Update() {}
};

struct TextureComponent : public Component {
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

// Question: Do the 'actions' or 'systems' belong in the monolithic class?
//           Hmmmmmmmmmmmm?
enum class RenderState{VISIBLE,INVISIBLE};
bool CollidingWithFloor(/*GameObject& World*/){ /*...*/ return true; }
RenderState  GetRenderState() { return RenderState::VISIBLE; }
void PlaySound() { /* ... */ };


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
    void Update(){
        for(auto& component : mComponents){
            component->Update();
        }
    }

    template<typename T>
    void AddComponent(T* c){
        mComponents.emplace_back(c);
    }

    template<typename T>
    T GetComponentAtIndex(size_t index){
         return mComponents[index]; 
    }

    public:
        /// GameObject Components
    std::vector<Component*> mComponents;
    /// Unique ID per Game Object
    uint64_t mID;
    /// For demonstration, we have an atomic counter
    /// that can assign unique ID's to the mID.
    inline static std::atomic<uint64_t> sID{0};
};

/*
// Here are our list of components
struct TextureComponent{};
struct CollisionBoxComponent{};
struct TransformComponent{};
struct StateComponent{};
struct InputComponent{};
struct UserInterface2DComponent{};
struct AIBehaviorComponent{};

enum class RenderState{VISIBLE,INVISIBLE};

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
    
    // Question: Is there interesting coupling here....
    //           Hmmmmmmmmmmm?
    void Update(){
        if( CollidingWithFloor() 
            && (GetRenderState() != RenderState::INVISIBLE)){
           PlaySound(); 
        }
    }

    // Question: Do the 'actions' or 'systems' belong in the monolithic class?
    //           Hmmmmmmmmmmmm?
    bool CollidingWithFloor(){  return true; }
    RenderState  GetRenderState() { return RenderState::VISIBLE; }
    void PlaySound() { };
    public:
        /// Common Components
        TextureComponent*         mTexture{nullptr};
        CollisionBoxComponent*    mCollision{nullptr};
        TransformComponent*       mTransform{nullptr};
        StateComponent*           mState{nullptr};
        InputComponent*           mInput{nullptr};
        UserInterface2DComponent* mUserInterface{nullptr}; 
        AIBehaviorComponent*      mAI{nullptr};
    /// Unique ID per Game Object
    uint64_t mID;
    /// For demonstration, we have an atomic counter
    /// that can assign unique ID's to the mID.
    inline static std::atomic<uint64_t> sID{0};
};

*/
