// Inheritance/GameObject.hpp
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
    protected:
        /// Common Components
        Texture         mTexture;
        CollisionBox    mCollision;
        Transform       mTransform;
        State           mState;
    /// Unique ID per Game Object
    uint64_t mID;
    /// For demonstration, we have an atomic counter
    /// that can assign unique ID's to the mID.
    inline static std::atomic<uint64_t> sID{0};
};

/// New Mario
struct Mario : public GameObject{
    protected:
        Input           mInput;
        UserInterface2D mUserInterface; 
};

/// New AI
struct AI : public GameObject{
    protected:
        AIBehavior      mAI;
};

/// Example Usage:
///
/// GameObject* Mario = new Mario();
