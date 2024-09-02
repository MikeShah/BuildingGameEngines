// @file d_sdl_binding_example/sdl_dlang.d
// Compiling and running: dmd sdl_dlang.d -L`pkg-config --libs sdl2` -of=prog
import std.stdio;

// Struct prototype 
struct SDL_Window;
struct SDL_Surface;

// Enums
enum : uint{SDL_INIT_TIMER          = 0x00000001,
            SDL_INIT_AUDIO          = 0x00000010,
            SDL_INIT_VIDEO          = 0x00000020,
            SDL_INIT_JOYSTICK       = 0x00000200,
            SDL_INIT_HAPTIC         = 0x00001000,
            SDL_INIT_GAMECONTROLLER = 0x00002000,      /**< turn on game controller also implicitly does JOYSTICK */
            SDL_INIT_NOPARACHUTE    = 0x00100000,      /**< Don't catch fatal signals */
            SDL_INIT_EVERYTHING     = (SDL_INIT_TIMER | SDL_INIT_AUDIO | SDL_INIT_VIDEO | 
									  SDL_INIT_JOYSTICK | SDL_INIT_HAPTIC | SDL_INIT_GAMECONTROLLER) };

uint SDL_WINDOWPOS_UNDEFINED_MASK  			= 0x1FFF0000u;
uint SDL_WINDOWPOS_UNDEFINED_DISPLAY(uint X) { return SDL_WINDOWPOS_UNDEFINED_MASK | X ; 	}
uint SDL_WINDOWPOS_UNDEFINED()  			 { return SDL_WINDOWPOS_UNDEFINED_DISPLAY(0); 	}
uint SDLWINDOWPOS_ISUNDEFINED(uint X) 		 { return (((X)&0xFFFF0000) == SDL_WINDOWPOS_UNDEFINED_MASK);}

alias SDL_WindowFlags = uint;
enum : uint
{
    SDL_WINDOW_FULLSCREEN = 0x00000001,         /**< fullscreen window */
    SDL_WINDOW_OPENGL = 0x00000002,             /**< window usable with OpenGL context */
    SDL_WINDOW_SHOWN = 0x00000004,              /**< window is visible */
    SDL_WINDOW_HIDDEN = 0x00000008,             /**< window is not visible */
    SDL_WINDOW_BORDERLESS = 0x00000010,         /**< no window decoration */
    SDL_WINDOW_RESIZABLE = 0x00000020,          /**< window can be resized */
    SDL_WINDOW_MINIMIZED = 0x00000040,          /**< window is minimized */
    SDL_WINDOW_MAXIMIZED = 0x00000080,          /**< window is maximized */
    SDL_WINDOW_MOUSE_GRABBED = 0x00000100,      /**< window has grabbed mouse input */
    SDL_WINDOW_INPUT_FOCUS = 0x00000200,        /**< window has input focus */
    SDL_WINDOW_MOUSE_FOCUS = 0x00000400,        /**< window has mouse focus */
    SDL_WINDOW_FULLSCREEN_DESKTOP = ( SDL_WINDOW_FULLSCREEN | 0x00001000 ),
    SDL_WINDOW_FOREIGN = 0x00000800,            /**< window not created by SDL */
    SDL_WINDOW_ALLOW_HIGHDPI = 0x00002000,      /**< window should be created in high-DPI mode if supported.
                                                     On macOS NSHighResolutionCapable must be set true in the
                                                     application's Info.plist for this to have any effect. */
    SDL_WINDOW_MOUSE_CAPTURE    = 0x00004000,   /**< window has mouse captured (unrelated to MOUSE_GRABBED) */
    SDL_WINDOW_ALWAYS_ON_TOP    = 0x00008000,   /**< window should always be above others */
    SDL_WINDOW_SKIP_TASKBAR     = 0x00010000,   /**< window should not be added to the taskbar */
    SDL_WINDOW_UTILITY          = 0x00020000,   /**< window should be treated as a utility window */
    SDL_WINDOW_TOOLTIP          = 0x00040000,   /**< window should be treated as a tooltip */
    SDL_WINDOW_POPUP_MENU       = 0x00080000,   /**< window should be treated as a popup menu */
    SDL_WINDOW_KEYBOARD_GRABBED = 0x00100000,   /**< window has grabbed keyboard input */
    SDL_WINDOW_VULKAN           = 0x10000000,   /**< window usable for Vulkan surface */
    SDL_WINDOW_METAL            = 0x20000000,   /**< window usable for Metal view */

    SDL_WINDOW_INPUT_GRABBED = SDL_WINDOW_MOUSE_GRABBED /**< equivalent to SDL_WINDOW_MOUSE_GRABBED for compatibility */
} ;

// C Functions
extern(C){
    int SDL_Init(uint);
    void SDL_Delay(uint);
    SDL_Window* SDL_CreateWindow(const char *title, int x, int y, int w, int h, SDL_WindowFlags flags);
}
                                                    
void main(){
    SDL_Window* window;
    SDL_Surface* surface;

    if(SDL_Init(SDL_INIT_VIDEO) <0){
       writeln("Could not initialize SDL Video"); 
    }

    window = SDL_CreateWindow("A Full SDL Program with D Binding",
                              0,0,
                              800,600,SDL_WINDOW_SHOWN);
    
    if(null==window){
        writeln("Could not create window"); 
    }

    SDL_Delay(2000);
}

