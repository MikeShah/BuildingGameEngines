# For linux 

For SDL2 you need to install: `libsdl2-mixer-dev`

e.g. `sudo apt-get install libsdl2-mixer-dev`

## Building SDL_Mixer 2.8

If you're using SDL_Mixer2 for SDL2, I'd recommend downloading and building SDL_Mixer from source.

On my machine I was missing opusfile which is used for 'ogg'

I installed with: `sudo apt-get install libopusfile-dev`
I then installed: `sudo apt-get install libxmp-dev`
I then installed: `sudo apt-get install libfluidsynth-dev libwavpack-dev`

Just follow whatever cmake is telling you that you are missing.
