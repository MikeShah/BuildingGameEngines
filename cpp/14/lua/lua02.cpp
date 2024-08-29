// @file lua02.cpp
//
// g++ -g -std=c++20 lua02.cpp -I./lua-5.4.4/src -L./lua-5.4.4/src -o prog -llua
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

    // Push some numbers onto the lua stack
    lua_pushnumber(L, 20);
    lua_pushnumber(L, 30);
    lua_pushnumber(L, 40);

    // Read a number from the lua stack
    // Note: We can index into the stack using both postive
    //       and negative numbers.
    lua_Number x = lua_tonumber(L,1); // 1 is top of the stack
    lua_Number y = lua_tonumber(L,2);
    lua_Number z = lua_tonumber(L,3);

    std::cout << "x is: " << x << std::endl;                                
    std::cout << "y is: " << y << std::endl;                                
    std::cout << "z is: " << z << std::endl << std::endl; 

    // We can also remove numbers from the stack if we like
    lua_remove(L,1);
    x = lua_tonumber(L,1);
    std::cout << "x is: " << x << std::endl;                                
 
    // Clean up our luaL state.
    lua_close(L);


    return 0;
}
