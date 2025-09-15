#!/bin/sh

dmd -c dll.d -fPIC
dmd dll.o -shared -of=libdll.so -defaultlib=libphobos2.so -L-rpath=.

dmd -c main.d
dmd main.o -L-ldl -defaultlib=libphobos2.so -L-rpath=. -map -of=prog

./prog

rm main.o dll.o libdll.so prog prog.map
