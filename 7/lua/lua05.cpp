// @file lua05.cpp
//
// g++ -g -std=c++20 lua05.cpp -I./lua-5.4.4/src -L./lua-5.4.4/src -o prog -llua
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

// This is going to be a Native C++ function that we
// will call from lua.
int AddCpp(lua_State* L){
    std::cout << "[Calling into C++]\n";
    // Grab number from the top of the stack.
    // The first value represents the 'argument' into this function
    lua_Number a = lua_tonumber(L,-2);
    lua_Number b = lua_tonumber(L,-1);

    // This value represents the return value
    lua_Number result = a+b;
    lua_pushnumber(L,result);

    // Return value is how much data is left on the stack
    return 1;
}

int main(){

    // Creates a new lua state
    lua_State* L = luaL_newstate(); // alternatively lua_newstate

    // Push our c function onto the lua stack.
    lua_pushcfunction(L,AddCpp);
    // Now we 'register' this function in lua.
    lua_setglobal(L,"AddCpp");

    // Execute a lua file    
//    luaL_dofile(L,"lua05.lua");
    // Get a global function
    // Since we just executed it, the function should
    // be on the top of the stack.
    lua_getglobal(L,"AddCpp");
    // We can then check if what we have retrieved
    // on the stack is a function and then call it.
    if(lua_isfunction(L,1)){
        // Push on two arguments
        lua_pushnumber(L,500);
        lua_pushnumber(L,200);
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
