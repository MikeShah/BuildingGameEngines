
Make sure to compile dll.d to a shared library first

`dmd -c dll.d -fPIC`
`dmd dll.o -shared -of=libdll.so -defaultlib=libphobos2.so -L-rpath=.`

Then compile the main program. 
The main program will load in the dll and its functions at run-time.

`dmd -c main.d`
`dmd main.o -L-ldl -defaultlib=libphobos2.so -L-rpath=. -map -of=prog`


