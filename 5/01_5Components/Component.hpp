// Components/Component.hpp
#pragma once
#include <atomic>

struct Component{
    /// Constructor
    Component(){
    }

    /// Destructor
    /// Note: May need 'virtual destructor if we alloate
    ///       in 'Base Component
    virtual ~Component(){}

    private:
    /// Data for components
};


/// Example Usage:
///
/// Component* Base = new Component();
