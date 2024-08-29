// @file lua03.cpp
//
// g++ -g -std=c++20 lua03.cpp -I./lua-5.4.4/src -L./lua-5.4.4/src -o prog -llua
// -------------------i-------
// // Compile                  -----------------------------------         -----
//                             Set include and library paths               link in lua
//                                                                 ------
//                                                                 prog 

// C++ Standard Libraies
#include <iostream>
// Lua
extern "C" {
    #include "lua.h"
    #include "lauxlib.h"
    #include "lualib.h"
}

int main(){

    // Creates a new lua state
    lua_State* L = luaL_newstate(); // alternatively lua_newstate

    // Execute a lua file    
    luaL_dofile(L,"lua03.lua");
    // Get a global function
    // Since we just executed it, the function should
    // be on the top of the stack.
    lua_getglobal(L,"Return123");
    // We can then check if what we have retrieved
    // on the stack is a function and then call it.
    if(lua_isfunction(L,1)){
        //        args, return, and ??? (error code?)
        lua_pcall(L,0,1,0);
    }
    // Get the result of our function which will be on the
    // top of the stack.
    lua_Number x = lua_tonumber(L,1);
    // Print out the result
    std::cout << "return result is: " << x << std::endl;

    // Clean up our luaL state.
    lua_close(L);


    return 0;
}
