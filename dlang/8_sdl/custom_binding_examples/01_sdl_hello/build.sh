# Simple build script
# Remember to 'link in SDL'
#
# Tools like 'pkg-config' can also help
# e.g.
# pkg-config --libs sdl2
#
# Usage: dmd source/*.d -L`pkg-config --libs sdl2` -of=prog
#
# Linux
dmd source/*.d -L-lSDL2 -of=prog
