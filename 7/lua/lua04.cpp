// @file lua04.cpp
//
// g++ -g -std=c++20 lua04.cpp -I./lua-5.4.4/src -L./lua-5.4.4/src -o prog -llua
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
    luaL_dofile(L,"lua04.lua");
    // Get a global function
    // Since we just executed it, the function should
    // be on the top of the stack.
    lua_getglobal(L,"add");
    // We can then check if what we have retrieved
    // on the stack is a function and then call it.
    if(lua_isfunction(L,1)){
        // Push on two arguments
        lua_pushnumber(L,5);
        lua_pushnumber(L,2);
        lua_Number a = lua_tonumber(L,2);
        lua_Number b = lua_tonumber(L,3);
        constexpr int args= 2;
        constexpr int number_of_return_values= 1;
        //        args, return, and ??? (error code?)
        lua_pcall(L,args,number_of_return_values,0);
        // Get the result of our function which will be on the
        // top of the stack.
        lua_Number result_of_add = lua_tonumber(L,1);
        // Print out the result
        std::cout << "add(" << a << "," << b << ") is: " << result_of_add << std::endl;
    }

    // Clean up our luaL state.
    lua_close(L);


    return 0;
}
