// @file lua01.cpp
//
// g++ -g -std=c++20 lua01.cpp -I./lua-5.4.4/src -L./lua-5.4.4/src -o prog -llua
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
                                    
    // For a current lua_state, we can execute some arbitrary code.
    luaL_dostring(L,"x=42");
    // retrieve a global variable
    // This pushes 'x' on top of a stack.
    // The 'stack' makes things relatively simple to work with.
    lua_getglobal(L, "x");
    // Retrieve a number from lua
    // Only a few types in lua, lua_Number being one of them
    // 1. nil       2. boolean  3. light userdata (like a pointer
    // 4. number    5. string   6. table - only complex data type -- associative array
    // 7. function  8. userdata (for new types) 9. thread (it's a coroutine)
    lua_Number x = lua_tonumber(L,1);

    // Print out our result from C++
    std::cout << "x from lua is: " << x << std::endl;
    
    // Clean up our luaL state.
    lua_close(L);

    return 0;
}
