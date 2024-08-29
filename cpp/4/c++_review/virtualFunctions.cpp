#include <iostream>

class Type1{
    public:
    char grade;
    int value;

    virtual void foo(){
        std::cout << "Type1 foo" << std::endl;
    }
};


// Type2 is derived from the base class
// Type1
class Type2 : public Type1{

    public:
    void foo(){
        std::cout << "No actually, use Type2's version of foo" << std::endl;
    }
};


int main(){

    Type1* mike = new Type2;
    mike->value = 7;
    mike->grade = 'B';
    // Which version is called
    mike->foo();
    
    Type1* mikeagain = new Type1;
    // Which version is called?
    mikeagain->foo();

    // Exercise: Try taking away 'virtual' in Type1 and repeating

    return 0;
}
