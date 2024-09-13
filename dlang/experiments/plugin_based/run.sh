dmd -c dll.d -fPIC
dmd -oflibdll.so dll.o -shared

dmd -c main.o -L-ldl -L-rpath=. -map -of=main
dmd main.o -L-ldl -L-rpath=. -map

./main
