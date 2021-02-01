// clang++ -std=c++11 6_static.cpp -o static

int main(){

    static_assert(sizeof(int) == 4,"int is not 4 on this architecture");

    static_assert(sizeof(int) == 8,"int is something other than 8 bytes");
    
    return 0;
}
