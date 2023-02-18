#include <pybind11/pybind11.h>

int add(int i, int j){

    return i+j;
}

int mult(int i, int j){

    return i*j;
}

PYBIND11_MODULE(example, m){
    m.doc() = "3520 example";
    m.def("add",&add,"function that adds two ints");
    m.def("mult",&mult,"function that multiplies two ints");

}
