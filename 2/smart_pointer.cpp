// smart_pointer.cpp
//
// Idea is the pointer can have extra information
// Like how many references or 'things' point to it
// so we can safely deallocate the pointer.
template <class T>
struct SmartPointer{
    T* myPointer;
    int references;

    private:
    SmartPointer(){
    }

};

int main(){

    // nullptr is C++'s type for 'NULL'
    float* f = nullptr;

    SmartPointer<float> p_mike;
    p_mike.myPointer = &f;

    return 0;
}



