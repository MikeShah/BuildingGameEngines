# Simple build script
# Remember to 'link in SDL'
#
# Tools like 'pkg-config' can also help
# e.g.
# pkg-config --libs sdl3
#
# Usage: dmd -g source/*.d -L`pkg-config --libs sdl3` -of=prog
#
# Linux
dmd -g source/*.d -L-lSDL3 -of=prog
