// MonolithicGameObject/GameObject.hpp
#pragma once
#include <atomic>
// Here are our list of components
struct Texture{};
struct CollisionBox{};
struct Transform{};
struct State{};
struct Input{};
struct UserInterface2D{};
struct AIBehavior{};

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
    bool CollidingWithFloor(/*GameObject& World*/){ /*...*/ return true; }
    RenderState  GetRenderState() { return RenderState::VISIBLE; }
    void PlaySound() { /* ... */ };

    public:
        /// Common Components
        Texture*         mTexture{nullptr};
        CollisionBox*    mCollision{nullptr};
        Transform*       mTransform{nullptr};
        State*           mState{nullptr};
        Input*           mInput{nullptr};
        UserInterface2D* mUserInterface{nullptr}; 
        AIBehavior*      mAI{nullptr};
    /// Unique ID per Game Object
    uint64_t mID;
    /// For demonstration, we have an atomic counter
    /// that can assign unique ID's to the mID.
    inline static std::atomic<uint64_t> sID{0};
};

/// Example Usage:
///
/// GameObject* Mario = new GameObject();
/// Mario->mTexture = new Texture;
