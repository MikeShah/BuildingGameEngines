// Components/GameObject.hpp
#pragma once
#include <atomic>

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

    private:
    /// Unique ID per Game Object
    uint64_t mID;
    /// For demonstration, we have an atomic counter
    /// that can assign unique ID's to the mID.
    inline static std::atomic<uint64_t> sID{0};
};


/// Example Usage:
///
/// GameObject* Mario = new GameObject();
