// Struct prototype
struct SDL_Window;
struct SDL_RWops;
struct SDL_Renderer;
struct SDL_PixelFormat;

// TODO Fix these
alias SDL_JoystickID = uint;
alias SDL_WindowID = uint;
alias SDL_KeyboardID = uint;
alias SDL_FingerID = uint;
alias SDL_PenID = uint;
alias SDL_MouseID = uint;
alias SDL_AudioDeviceID = uint;
alias SDL_PenAxis = uint;
alias SDL_SensorID = uint;
alias SDL_DisplayID = uint;
alias SDL_Keymod = uint;
alias SDL_PowerState = uint;
alias SDL_CameraID = uint;
alias SDL_TouchID = uint;
alias SDL_MouseWheelDirection = int;


alias SDL_PenInputFlags = uint;
alias SDL_MouseButtonFlags = uint;



alias SDL_InitFlags = uint;

struct SDL_Rect
{
		int x, y;
		int w, h;
}
struct SDL_FRect
{
		float x, y;
		float w, h;
}
struct SDL_Texture;

struct SDL_Keysym
{
		SDL_Scancode scancode;      /**< SDL physical key code - see SDL_Scancode for details */
		SDL_Keycode sym;            /**< SDL virtual key code - see SDL_Keycode for details */
		ushort mod;                 /**< current key modifiers */
		uint unused;
}
enum SDL_Scancode
{
		SDL_SCANCODE_UNKNOWN = 0,
		SDL_SCANCODE_A = 4,
		SDL_SCANCODE_B = 5,
		SDL_SCANCODE_C = 6,
		SDL_SCANCODE_D = 7,
		SDL_SCANCODE_E = 8,
		SDL_SCANCODE_F = 9,
		SDL_SCANCODE_G = 10,
		SDL_SCANCODE_H = 11,
		SDL_SCANCODE_I = 12,
		SDL_SCANCODE_J = 13,
		SDL_SCANCODE_K = 14,
		SDL_SCANCODE_L = 15,
		SDL_SCANCODE_M = 16,
		SDL_SCANCODE_N = 17,
		SDL_SCANCODE_O = 18,
		SDL_SCANCODE_P = 19,
		SDL_SCANCODE_Q = 20,
		SDL_SCANCODE_R = 21,
		SDL_SCANCODE_S = 22,
		SDL_SCANCODE_T = 23,
		SDL_SCANCODE_U = 24,
		SDL_SCANCODE_V = 25,
		SDL_SCANCODE_W = 26,
		SDL_SCANCODE_X = 27,
		SDL_SCANCODE_Y = 28,
		SDL_SCANCODE_Z = 29,

		SDL_SCANCODE_1 = 30,
		SDL_SCANCODE_2 = 31,
		SDL_SCANCODE_3 = 32,
		SDL_SCANCODE_4 = 33,
		SDL_SCANCODE_5 = 34,
		SDL_SCANCODE_6 = 35,
		SDL_SCANCODE_7 = 36,
		SDL_SCANCODE_8 = 37,
		SDL_SCANCODE_9 = 38,
		SDL_SCANCODE_0 = 39,

		SDL_SCANCODE_RETURN = 40,
		SDL_SCANCODE_ESCAPE = 41,
		SDL_SCANCODE_BACKSPACE = 42,
		SDL_SCANCODE_TAB = 43,
		SDL_SCANCODE_SPACE = 44,

		SDL_SCANCODE_MINUS = 45,
		SDL_SCANCODE_EQUALS = 46,
		SDL_SCANCODE_LEFTBRACKET = 47,
		SDL_SCANCODE_RIGHTBRACKET = 48,
		SDL_SCANCODE_BACKSLASH = 49, /**< Located at the lower left of the return
																	*   key on ISO keyboards and at the right end
																	*   of the QWERTY row on ANSI keyboards.
																	*   Produces REVERSE SOLIDUS (backslash) and
																	*   VERTICAL LINE in a US layout, REVERSE
																	*   SOLIDUS and VERTICAL LINE in a UK Mac
																	*   layout, NUMBER SIGN and TILDE in a UK
																	*   Windows layout, DOLLAR SIGN and POUND SIGN
																	*   in a Swiss German layout, NUMBER SIGN and
																	*   APOSTROPHE in a German layout, GRAVE
																	*   ACCENT and POUND SIGN in a French Mac
																	*   layout, and ASTERISK and MICRO SIGN in a
																	*   French Windows layout.
																	*/
		SDL_SCANCODE_NONUSHASH = 50, /**< ISO USB keyboards actually use this code
																	*   instead of 49 for the same key, but all
																	*   OSes I've seen treat the two codes
																	*   identically. So, as an implementor, unless
																	*   your keyboard generates both of those
																	*   codes and your OS treats them differently,
																	*   you should generate SDL_SCANCODE_BACKSLASH
																	*   instead of this code. As a user, you
																	*   should not rely on this code because SDL
																	*   will never generate it with most (all?)
																	*   keyboards.
																	*/
		SDL_SCANCODE_SEMICOLON = 51,
		SDL_SCANCODE_APOSTROPHE = 52,
		SDL_SCANCODE_GRAVE = 53, /**< Located in the top left corner (on both ANSI
															*   and ISO keyboards). Produces GRAVE ACCENT and
															*   TILDE in a US Windows layout and in US and UK
															*   Mac layouts on ANSI keyboards, GRAVE ACCENT
															*   and NOT SIGN in a UK Windows layout, SECTION
															*   SIGN and PLUS-MINUS SIGN in US and UK Mac
															*   layouts on ISO keyboards, SECTION SIGN and
															*   DEGREE SIGN in a Swiss German layout (Mac:
															*   only on ISO keyboards), CIRCUMFLEX ACCENT and
															*   DEGREE SIGN in a German layout (Mac: only on
															*   ISO keyboards), SUPERSCRIPT TWO and TILDE in a
															*   French Windows layout, COMMERCIAL AT and
															*   NUMBER SIGN in a French Mac layout on ISO
															*   keyboards, and LESS-THAN SIGN and GREATER-THAN
															*   SIGN in a Swiss German, German, or French Mac
															*   layout on ANSI keyboards.
															*/
		SDL_SCANCODE_COMMA = 54,
		SDL_SCANCODE_PERIOD = 55,
		SDL_SCANCODE_SLASH = 56,

		SDL_SCANCODE_CAPSLOCK = 57,

		SDL_SCANCODE_F1 = 58,
		SDL_SCANCODE_F2 = 59,
		SDL_SCANCODE_F3 = 60,
		SDL_SCANCODE_F4 = 61,
		SDL_SCANCODE_F5 = 62,
		SDL_SCANCODE_F6 = 63,
		SDL_SCANCODE_F7 = 64,
		SDL_SCANCODE_F8 = 65,
		SDL_SCANCODE_F9 = 66,
		SDL_SCANCODE_F10 = 67,
		SDL_SCANCODE_F11 = 68,
		SDL_SCANCODE_F12 = 69,

		SDL_SCANCODE_PRINTSCREEN = 70,
		SDL_SCANCODE_SCROLLLOCK = 71,
		SDL_SCANCODE_PAUSE = 72,
		SDL_SCANCODE_INSERT = 73, /**< insert on PC, help on some Mac keyboards (but
																does send code 73, not 117) */
		SDL_SCANCODE_HOME = 74,
		SDL_SCANCODE_PAGEUP = 75,
		SDL_SCANCODE_DELETE = 76,
		SDL_SCANCODE_END = 77,
		SDL_SCANCODE_PAGEDOWN = 78,
		SDL_SCANCODE_RIGHT = 79,
		SDL_SCANCODE_LEFT = 80,
		SDL_SCANCODE_DOWN = 81,
		SDL_SCANCODE_UP = 82,

		SDL_SCANCODE_NUMLOCKCLEAR = 83, /**< num lock on PC, clear on Mac keyboards
																		 */
		SDL_SCANCODE_KP_DIVIDE = 84,
		SDL_SCANCODE_KP_MULTIPLY = 85,
		SDL_SCANCODE_KP_MINUS = 86,
		SDL_SCANCODE_KP_PLUS = 87,
		SDL_SCANCODE_KP_ENTER = 88,
		SDL_SCANCODE_KP_1 = 89,
		SDL_SCANCODE_KP_2 = 90,
		SDL_SCANCODE_KP_3 = 91,
		SDL_SCANCODE_KP_4 = 92,
		SDL_SCANCODE_KP_5 = 93,
		SDL_SCANCODE_KP_6 = 94,
		SDL_SCANCODE_KP_7 = 95,
		SDL_SCANCODE_KP_8 = 96,
		SDL_SCANCODE_KP_9 = 97,
		SDL_SCANCODE_KP_0 = 98,
		SDL_SCANCODE_KP_PERIOD = 99,

		SDL_SCANCODE_NONUSBACKSLASH = 100, /**< This is the additional key that ISO
																				*   keyboards have over ANSI ones,
																				*   located between left shift and Y.
																				*   Produces GRAVE ACCENT and TILDE in a
																				*   US or UK Mac layout, REVERSE SOLIDUS
																				*   (backslash) and VERTICAL LINE in a
																				*   US or UK Windows layout, and
																				*   LESS-THAN SIGN and GREATER-THAN SIGN
																				*   in a Swiss German, German, or French
																				*   layout. */
		SDL_SCANCODE_APPLICATION = 101, /**< windows contextual menu, compose */
		SDL_SCANCODE_POWER = 102, /**< The USB document says this is a status flag,
															 *   not a physical key - but some Mac keyboards
															 *   do have a power key. */
		SDL_SCANCODE_KP_EQUALS = 103,
		SDL_SCANCODE_F13 = 104,
		SDL_SCANCODE_F14 = 105,
		SDL_SCANCODE_F15 = 106,
		SDL_SCANCODE_F16 = 107,
		SDL_SCANCODE_F17 = 108,
		SDL_SCANCODE_F18 = 109,
		SDL_SCANCODE_F19 = 110,
		SDL_SCANCODE_F20 = 111,
		SDL_SCANCODE_F21 = 112,
		SDL_SCANCODE_F22 = 113,
		SDL_SCANCODE_F23 = 114,
		SDL_SCANCODE_F24 = 115,
		SDL_SCANCODE_EXECUTE = 116,
		SDL_SCANCODE_HELP = 117,    /**< AL Integrated Help Center */
		SDL_SCANCODE_MENU = 118,    /**< Menu (show menu) */
		SDL_SCANCODE_SELECT = 119,
		SDL_SCANCODE_STOP = 120,    /**< AC Stop */
		SDL_SCANCODE_AGAIN = 121,   /**< AC Redo/Repeat */
		SDL_SCANCODE_UNDO = 122,    /**< AC Undo */
		SDL_SCANCODE_CUT = 123,     /**< AC Cut */
		SDL_SCANCODE_COPY = 124,    /**< AC Copy */
		SDL_SCANCODE_PASTE = 125,   /**< AC Paste */
		SDL_SCANCODE_FIND = 126,    /**< AC Find */
		SDL_SCANCODE_MUTE = 127,
		SDL_SCANCODE_VOLUMEUP = 128,
		SDL_SCANCODE_VOLUMEDOWN = 129,
		SDL_SCANCODE_KP_COMMA = 133,
		SDL_SCANCODE_KP_EQUALSAS400 = 134,

		SDL_SCANCODE_INTERNATIONAL1 = 135, /**< used on Asian keyboards, see
																				 footnotes in USB doc */
		SDL_SCANCODE_INTERNATIONAL2 = 136,
		SDL_SCANCODE_INTERNATIONAL3 = 137, /**< Yen */
		SDL_SCANCODE_INTERNATIONAL4 = 138,
		SDL_SCANCODE_INTERNATIONAL5 = 139,
		SDL_SCANCODE_INTERNATIONAL6 = 140,
		SDL_SCANCODE_INTERNATIONAL7 = 141,
		SDL_SCANCODE_INTERNATIONAL8 = 142,
		SDL_SCANCODE_INTERNATIONAL9 = 143,
		SDL_SCANCODE_LANG1 = 144, /**< Hangul/English toggle */
		SDL_SCANCODE_LANG2 = 145, /**< Hanja conversion */
		SDL_SCANCODE_LANG3 = 146, /**< Katakana */
		SDL_SCANCODE_LANG4 = 147, /**< Hiragana */
		SDL_SCANCODE_LANG5 = 148, /**< Zenkaku/Hankaku */
		SDL_SCANCODE_LANG6 = 149, /**< reserved */
		SDL_SCANCODE_LANG7 = 150, /**< reserved */
		SDL_SCANCODE_LANG8 = 151, /**< reserved */
		SDL_SCANCODE_LANG9 = 152, /**< reserved */

		SDL_SCANCODE_ALTERASE = 153,    /**< Erase-Eaze */
		SDL_SCANCODE_SYSREQ = 154,
		SDL_SCANCODE_CANCEL = 155,      /**< AC Cancel */
		SDL_SCANCODE_CLEAR = 156,
		SDL_SCANCODE_PRIOR = 157,
		SDL_SCANCODE_RETURN2 = 158,
		SDL_SCANCODE_SEPARATOR = 159,
		SDL_SCANCODE_OUT = 160,
		SDL_SCANCODE_OPER = 161,
		SDL_SCANCODE_CLEARAGAIN = 162,
		SDL_SCANCODE_CRSEL = 163,
		SDL_SCANCODE_EXSEL = 164,

		SDL_SCANCODE_KP_00 = 176,
		SDL_SCANCODE_KP_000 = 177,
		SDL_SCANCODE_THOUSANDSSEPARATOR = 178,
		SDL_SCANCODE_DECIMALSEPARATOR = 179,
		SDL_SCANCODE_CURRENCYUNIT = 180,
		SDL_SCANCODE_CURRENCYSUBUNIT = 181,
		SDL_SCANCODE_KP_LEFTPAREN = 182,
		SDL_SCANCODE_KP_RIGHTPAREN = 183,
		SDL_SCANCODE_KP_LEFTBRACE = 184,
		SDL_SCANCODE_KP_RIGHTBRACE = 185,
		SDL_SCANCODE_KP_TAB = 186,
		SDL_SCANCODE_KP_BACKSPACE = 187,
		SDL_SCANCODE_KP_A = 188,
		SDL_SCANCODE_KP_B = 189,
		SDL_SCANCODE_KP_C = 190,
		SDL_SCANCODE_KP_D = 191,
		SDL_SCANCODE_KP_E = 192,
		SDL_SCANCODE_KP_F = 193,
		SDL_SCANCODE_KP_XOR = 194,
		SDL_SCANCODE_KP_POWER = 195,
		SDL_SCANCODE_KP_PERCENT = 196,
		SDL_SCANCODE_KP_LESS = 197,
		SDL_SCANCODE_KP_GREATER = 198,
		SDL_SCANCODE_KP_AMPERSAND = 199,
		SDL_SCANCODE_KP_DBLAMPERSAND = 200,
		SDL_SCANCODE_KP_VERTICALBAR = 201,
		SDL_SCANCODE_KP_DBLVERTICALBAR = 202,
		SDL_SCANCODE_KP_COLON = 203,
		SDL_SCANCODE_KP_HASH = 204,
		SDL_SCANCODE_KP_SPACE = 205,
		SDL_SCANCODE_KP_AT = 206,
		SDL_SCANCODE_KP_EXCLAM = 207,
		SDL_SCANCODE_KP_MEMSTORE = 208,
		SDL_SCANCODE_KP_MEMRECALL = 209,
		SDL_SCANCODE_KP_MEMCLEAR = 210,
		SDL_SCANCODE_KP_MEMADD = 211,
		SDL_SCANCODE_KP_MEMSUBTRACT = 212,
		SDL_SCANCODE_KP_MEMMULTIPLY = 213,
		SDL_SCANCODE_KP_MEMDIVIDE = 214,
		SDL_SCANCODE_KP_PLUSMINUS = 215,
		SDL_SCANCODE_KP_CLEAR = 216,
		SDL_SCANCODE_KP_CLEARENTRY = 217,
		SDL_SCANCODE_KP_BINARY = 218,
		SDL_SCANCODE_KP_OCTAL = 219,
		SDL_SCANCODE_KP_DECIMAL = 220,
		SDL_SCANCODE_KP_HEXADECIMAL = 221,

		SDL_SCANCODE_LCTRL = 224,
		SDL_SCANCODE_LSHIFT = 225,
		SDL_SCANCODE_LALT = 226, /**< alt, option */
		SDL_SCANCODE_LGUI = 227, /**< windows, command (apple), meta */
		SDL_SCANCODE_RCTRL = 228,
		SDL_SCANCODE_RSHIFT = 229,
		SDL_SCANCODE_RALT = 230, /**< alt gr, option */
		SDL_SCANCODE_RGUI = 231, /**< windows, command (apple), meta */

		SDL_SCANCODE_MODE = 257,    /**< I'm not sure if this is really not covered
																 *   by any of the above, but since there's a
																 *   special KMOD_MODE for it I'm adding it here
																 */
		SDL_SCANCODE_AUDIONEXT = 258,
		SDL_SCANCODE_AUDIOPREV = 259,
		SDL_SCANCODE_AUDIOSTOP = 260,
		SDL_SCANCODE_AUDIOPLAY = 261,
		SDL_SCANCODE_AUDIOMUTE = 262,
		SDL_SCANCODE_MEDIASELECT = 263,
		SDL_SCANCODE_WWW = 264,             /**< AL Internet Browser */
		SDL_SCANCODE_MAIL = 265,
		SDL_SCANCODE_CALCULATOR = 266,      /**< AL Calculator */
		SDL_SCANCODE_COMPUTER = 267,
		SDL_SCANCODE_AC_SEARCH = 268,       /**< AC Search */
		SDL_SCANCODE_AC_HOME = 269,         /**< AC Home */
		SDL_SCANCODE_AC_BACK = 270,         /**< AC Back */
		SDL_SCANCODE_AC_FORWARD = 271,      /**< AC Forward */
		SDL_SCANCODE_AC_STOP = 272,         /**< AC Stop */
		SDL_SCANCODE_AC_REFRESH = 273,      /**< AC Refresh */
		SDL_SCANCODE_AC_BOOKMARKS = 274,    /**< AC Bookmarks */
		SDL_SCANCODE_BRIGHTNESSDOWN = 275,
		SDL_SCANCODE_BRIGHTNESSUP = 276,
		SDL_SCANCODE_DISPLAYSWITCH = 277, /**< display mirroring/dual display
																				switch, video mode switch */
		SDL_SCANCODE_KBDILLUMTOGGLE = 278,
		SDL_SCANCODE_KBDILLUMDOWN = 279,
		SDL_SCANCODE_KBDILLUMUP = 280,
		SDL_SCANCODE_EJECT = 281,
		SDL_SCANCODE_SLEEP = 282,           /**< SC System Sleep */

		SDL_SCANCODE_APP1 = 283,
		SDL_SCANCODE_APP2 = 284,
		SDL_SCANCODE_AUDIOREWIND = 285,
		SDL_SCANCODE_AUDIOFASTFORWARD = 286,
		SDL_SCANCODE_SOFTLEFT = 287, /**< Usually situated below the display on phones and
																	 used as a multi-function feature key for selecting
																	 a software defined function shown on the bottom left
																	 of the display. */
		SDL_SCANCODE_SOFTRIGHT = 288, /**< Usually situated below the display on phones and
																		used as a multi-function feature key for selecting
																		a software defined function shown on the bottom right
																		of the display. */
		SDL_SCANCODE_CALL = 289, /**< Used for accepting phone calls. */
		SDL_SCANCODE_ENDCALL = 290, /**< Used for rejecting phone calls. */
		/* @} *//* Mobile keys */
		/* Add any other keys here. */
		SDL_NUM_SCANCODES = 512 /**< not a key, just marks the number of scancodes
															for array bounds */
		}
alias SDL_Keycode = int;

enum SDL_SCANCODE_MASK = 1<<30;
auto SDL_SCANCODE_TO_KEYCODE(int X) { return X | SDL_SCANCODE_MASK;};



enum : uint{

		SDL_INIT_AUDIO = 0x00000010u, /**< `SDL_INIT_AUDIO` implies `SDL_INIT_EVENTS` */
		SDL_INIT_VIDEO = 0x00000020u, /**< `SDL_INIT_VIDEO` implies `SDL_INIT_EVENTS`, should be initialized on the main thread */
		SDL_INIT_JOYSTICK = 0x00000200u, /**< `SDL_INIT_JOYSTICK` implies `SDL_INIT_EVENTS`, should be initialized on the same thread as SDL_INIT_VIDEO on Windows if you don't set SDL_HINT_JOYSTICK_THREAD */
		SDL_INIT_HAPTIC = 0x00001000u,
		SDL_INIT_GAMEPAD = 0x00002000u, /**< `SDL_INIT_GAMEPAD` implies `SDL_INIT_JOYSTICK` */
		SDL_INIT_EVENTS = 0x00004000u,
		SDL_INIT_SENSOR = 0x00008000u, /**< `SDL_INIT_SENSOR` implies `SDL_INIT_EVENTS` */
		SDL_INIT_CAMERA = 0x00010000u, /**< `SDL_INIT_CAMERA` implies `SDL_INIT_EVENTS` */
		}



alias SDL_WindowFlags = ulong;
enum : uint
{

 SDL_WINDOW_FULLSCREEN          = 0x0000000000000001u,    /**< window is in fullscreen mode */
 SDL_WINDOW_OPENGL              = 0x0000000000000002u,    /**< window usable with OpenGL context */
 SDL_WINDOW_OCCLUDED            = 0x0000000000000004u,    /**< window is occluded */
 SDL_WINDOW_HIDDEN              = 0x0000000000000008u,    /**< window is neither mapped onto the desktop nor shown in the taskbar/dock/window list; SDL_ShowWindow(u, is required for it to become visible */
 SDL_WINDOW_BORDERLESS          = 0x0000000000000010u,    /**< no window decoration */
 SDL_WINDOW_RESIZABLE           = 0x0000000000000020u,    /**< window can be resized */
 SDL_WINDOW_MINIMIZED           = 0x0000000000000040u,    /**< window is minimized */
 SDL_WINDOW_MAXIMIZED           = 0x0000000000000080u,    /**< window is maximized */
 SDL_WINDOW_MOUSE_GRABBED       = 0x0000000000000100u,    /**< window has grabbed mouse input */
 SDL_WINDOW_INPUT_FOCUS         = 0x0000000000000200u,    /**< window has input focus */
 SDL_WINDOW_MOUSE_FOCUS         = 0x0000000000000400u,    /**< window has mouse focus */
 SDL_WINDOW_EXTERNAL            = 0x0000000000000800u,    /**< window not created by SDL */
 SDL_WINDOW_MODAL               = 0x0000000000001000u,    /**< window is modal */
 SDL_WINDOW_HIGH_PIXEL_DENSITY  = 0x0000000000002000u,    /**< window uses high pixel density back buffer if possible */
 SDL_WINDOW_MOUSE_CAPTURE       = 0x0000000000004000u,    /**< window has mouse captured (unrelated to MOUSE_GRABBEDu, */
 SDL_WINDOW_MOUSE_RELATIVE_MODE = 0x0000000000008000u,    /**< window has relative mode enabled */
 SDL_WINDOW_ALWAYS_ON_TOP       = 0x0000000000010000u,    /**< window should always be above others */
 SDL_WINDOW_UTILITY             = 0x0000000000020000u,    /**< window should be treated as a utility window, not showing in the task bar and window list */
 SDL_WINDOW_TOOLTIP             = 0x0000000000040000u,    /**< window should be treated as a tooltip and does not get mouse or keyboard focus, requires a parent window */
 SDL_WINDOW_POPUP_MENU          = 0x0000000000080000u,    /**< window should be treated as a popup menu, requires a parent window */
 SDL_WINDOW_KEYBOARD_GRABBED    = 0x0000000000100000u,    /**< window has grabbed keyboard input */
 SDL_WINDOW_VULKAN              = 0x0000000010000000u,    /**< window usable for Vulkan surface */
 SDL_WINDOW_METAL               = 0x0000000020000000u,    /**< window usable for Metal view */
 SDL_WINDOW_TRANSPARENT         = 0x0000000040000000u,    /**< window with transparent buffer */
 SDL_WINDOW_NOT_FOCUSABLE       = 0x0000000080000000u,    /**< window should not be focusable */


} ;


// SDL_EventType
alias SDL_EventType = int;
enum : int
{
    SDL_EVENT_FIRST     = 0,     /**< Unused (do not remove) */

    /* Application events */
    SDL_EVENT_QUIT           = 0x100, /**< User-requested quit */

    /* These application events have special meaning on iOS and Android, see README-ios.md and README-android.md for details */
    SDL_EVENT_TERMINATING,      /**< The application is being terminated by the OS. This event must be handled in a callback set with SDL_AddEventWatch().
                                     Called on iOS in applicationWillTerminate()
                                     Called on Android in onDestroy()
                                */
    SDL_EVENT_LOW_MEMORY,       /**< The application is low on memory, free memory if possible. This event must be handled in a callback set with SDL_AddEventWatch().
                                     Called on iOS in applicationDidReceiveMemoryWarning()
                                     Called on Android in onTrimMemory()
                                */
    SDL_EVENT_WILL_ENTER_BACKGROUND, /**< The application is about to enter the background. This event must be handled in a callback set with SDL_AddEventWatch().
                                     Called on iOS in applicationWillResignActive()
                                     Called on Android in onPause()
                                */
    SDL_EVENT_DID_ENTER_BACKGROUND, /**< The application did enter the background and may not get CPU for some time. This event must be handled in a callback set with SDL_AddEventWatch().
                                     Called on iOS in applicationDidEnterBackground()
                                     Called on Android in onPause()
                                */
    SDL_EVENT_WILL_ENTER_FOREGROUND, /**< The application is about to enter the foreground. This event must be handled in a callback set with SDL_AddEventWatch().
                                     Called on iOS in applicationWillEnterForeground()
                                     Called on Android in onResume()
                                */
    SDL_EVENT_DID_ENTER_FOREGROUND, /**< The application is now interactive. This event must be handled in a callback set with SDL_AddEventWatch().
                                     Called on iOS in applicationDidBecomeActive()
                                     Called on Android in onResume()
                                */

    SDL_EVENT_LOCALE_CHANGED,  /**< The user's locale preferences have changed. */

    SDL_EVENT_SYSTEM_THEME_CHANGED, /**< The system theme changed */

    /* Display events */
    /* 0x150 was SDL_DISPLAYEVENT, reserve the number for sdl2-compat */
    SDL_EVENT_DISPLAY_ORIENTATION = 0x151,   /**< Display orientation has changed to data1 */
    SDL_EVENT_DISPLAY_ADDED,                 /**< Display has been added to the system */
    SDL_EVENT_DISPLAY_REMOVED,               /**< Display has been removed from the system */
    SDL_EVENT_DISPLAY_MOVED,                 /**< Display has changed position */
    SDL_EVENT_DISPLAY_DESKTOP_MODE_CHANGED,  /**< Display has changed desktop mode */
    SDL_EVENT_DISPLAY_CURRENT_MODE_CHANGED,  /**< Display has changed current mode */
    SDL_EVENT_DISPLAY_CONTENT_SCALE_CHANGED, /**< Display has changed content scale */
    SDL_EVENT_DISPLAY_FIRST = SDL_EVENT_DISPLAY_ORIENTATION,
    SDL_EVENT_DISPLAY_LAST = SDL_EVENT_DISPLAY_CONTENT_SCALE_CHANGED,

    /* Window events */
    /* 0x200 was SDL_WINDOWEVENT, reserve the number for sdl2-compat */
    /* 0x201 was SDL_SYSWMEVENT, reserve the number for sdl2-compat */
    SDL_EVENT_WINDOW_SHOWN = 0x202,     /**< Window has been shown */
    SDL_EVENT_WINDOW_HIDDEN,            /**< Window has been hidden */
    SDL_EVENT_WINDOW_EXPOSED,           /**< Window has been exposed and should be redrawn, and can be redrawn directly from event watchers for this event */
    SDL_EVENT_WINDOW_MOVED,             /**< Window has been moved to data1, data2 */
    SDL_EVENT_WINDOW_RESIZED,           /**< Window has been resized to data1xdata2 */
    SDL_EVENT_WINDOW_PIXEL_SIZE_CHANGED,/**< The pixel size of the window has changed to data1xdata2 */
    SDL_EVENT_WINDOW_METAL_VIEW_RESIZED,/**< The pixel size of a Metal view associated with the window has changed */
    SDL_EVENT_WINDOW_MINIMIZED,         /**< Window has been minimized */
    SDL_EVENT_WINDOW_MAXIMIZED,         /**< Window has been maximized */
    SDL_EVENT_WINDOW_RESTORED,          /**< Window has been restored to normal size and position */
    SDL_EVENT_WINDOW_MOUSE_ENTER,       /**< Window has gained mouse focus */
    SDL_EVENT_WINDOW_MOUSE_LEAVE,       /**< Window has lost mouse focus */
    SDL_EVENT_WINDOW_FOCUS_GAINED,      /**< Window has gained keyboard focus */
    SDL_EVENT_WINDOW_FOCUS_LOST,        /**< Window has lost keyboard focus */
    SDL_EVENT_WINDOW_CLOSE_REQUESTED,   /**< The window manager requests that the window be closed */
    SDL_EVENT_WINDOW_HIT_TEST,          /**< Window had a hit test that wasn't SDL_HITTEST_NORMAL */
    SDL_EVENT_WINDOW_ICCPROF_CHANGED,   /**< The ICC profile of the window's display has changed */
    SDL_EVENT_WINDOW_DISPLAY_CHANGED,   /**< Window has been moved to display data1 */
    SDL_EVENT_WINDOW_DISPLAY_SCALE_CHANGED, /**< Window display scale has been changed */
    SDL_EVENT_WINDOW_SAFE_AREA_CHANGED, /**< The window safe area has been changed */
    SDL_EVENT_WINDOW_OCCLUDED,          /**< The window has been occluded */
    SDL_EVENT_WINDOW_ENTER_FULLSCREEN,  /**< The window has entered fullscreen mode */
    SDL_EVENT_WINDOW_LEAVE_FULLSCREEN,  /**< The window has left fullscreen mode */
    SDL_EVENT_WINDOW_DESTROYED,         /**< The window with the associated ID is being or has been destroyed. If this message is being handled
                                             in an event watcher, the window handle is still valid and can still be used to retrieve any properties
                                             associated with the window. Otherwise, the handle has already been destroyed and all resources
                                             associated with it are invalid */
    SDL_EVENT_WINDOW_HDR_STATE_CHANGED, /**< Window HDR properties have changed */
    SDL_EVENT_WINDOW_FIRST = SDL_EVENT_WINDOW_SHOWN,
    SDL_EVENT_WINDOW_LAST = SDL_EVENT_WINDOW_HDR_STATE_CHANGED,

    /* Keyboard events */
    SDL_EVENT_KEY_DOWN        = 0x300, /**< Key pressed */
    SDL_EVENT_KEY_UP,                  /**< Key released */
    SDL_EVENT_TEXT_EDITING,            /**< Keyboard text editing (composition) */
    SDL_EVENT_TEXT_INPUT,              /**< Keyboard text input */
    SDL_EVENT_KEYMAP_CHANGED,          /**< Keymap changed due to a system event such as an
                                            input language or keyboard layout change. */
    SDL_EVENT_KEYBOARD_ADDED,          /**< A new keyboard has been inserted into the system */
    SDL_EVENT_KEYBOARD_REMOVED,        /**< A keyboard has been removed */
    SDL_EVENT_TEXT_EDITING_CANDIDATES, /**< Keyboard text editing candidates */

    /* Mouse events */
    SDL_EVENT_MOUSE_MOTION    = 0x400, /**< Mouse moved */
    SDL_EVENT_MOUSE_BUTTON_DOWN,       /**< Mouse button pressed */
    SDL_EVENT_MOUSE_BUTTON_UP,         /**< Mouse button released */
    SDL_EVENT_MOUSE_WHEEL,             /**< Mouse wheel motion */
    SDL_EVENT_MOUSE_ADDED,             /**< A new mouse has been inserted into the system */
    SDL_EVENT_MOUSE_REMOVED,           /**< A mouse has been removed */

    /* Joystick events */
    SDL_EVENT_JOYSTICK_AXIS_MOTION  = 0x600, /**< Joystick axis motion */
    SDL_EVENT_JOYSTICK_BALL_MOTION,          /**< Joystick trackball motion */
    SDL_EVENT_JOYSTICK_HAT_MOTION,           /**< Joystick hat position change */
    SDL_EVENT_JOYSTICK_BUTTON_DOWN,          /**< Joystick button pressed */
    SDL_EVENT_JOYSTICK_BUTTON_UP,            /**< Joystick button released */
    SDL_EVENT_JOYSTICK_ADDED,                /**< A new joystick has been inserted into the system */
    SDL_EVENT_JOYSTICK_REMOVED,              /**< An opened joystick has been removed */
    SDL_EVENT_JOYSTICK_BATTERY_UPDATED,      /**< Joystick battery level change */
    SDL_EVENT_JOYSTICK_UPDATE_COMPLETE,      /**< Joystick update is complete */

    /* Gamepad events */
    SDL_EVENT_GAMEPAD_AXIS_MOTION  = 0x650, /**< Gamepad axis motion */
    SDL_EVENT_GAMEPAD_BUTTON_DOWN,          /**< Gamepad button pressed */
    SDL_EVENT_GAMEPAD_BUTTON_UP,            /**< Gamepad button released */
    SDL_EVENT_GAMEPAD_ADDED,                /**< A new gamepad has been inserted into the system */
    SDL_EVENT_GAMEPAD_REMOVED,              /**< A gamepad has been removed */
    SDL_EVENT_GAMEPAD_REMAPPED,             /**< The gamepad mapping was updated */
    SDL_EVENT_GAMEPAD_TOUCHPAD_DOWN,        /**< Gamepad touchpad was touched */
    SDL_EVENT_GAMEPAD_TOUCHPAD_MOTION,      /**< Gamepad touchpad finger was moved */
    SDL_EVENT_GAMEPAD_TOUCHPAD_UP,          /**< Gamepad touchpad finger was lifted */
    SDL_EVENT_GAMEPAD_SENSOR_UPDATE,        /**< Gamepad sensor was updated */
    SDL_EVENT_GAMEPAD_UPDATE_COMPLETE,      /**< Gamepad update is complete */
    SDL_EVENT_GAMEPAD_STEAM_HANDLE_UPDATED,  /**< Gamepad Steam handle has changed */

    /* Touch events */
    SDL_EVENT_FINGER_DOWN      = 0x700,
    SDL_EVENT_FINGER_UP,
    SDL_EVENT_FINGER_MOTION,
    SDL_EVENT_FINGER_CANCELED,

    /* 0x800, 0x801, and 0x802 were the Gesture events from SDL2. Do not reuse these values! sdl2-compat needs them! */

    /* Clipboard events */
    SDL_EVENT_CLIPBOARD_UPDATE = 0x900, /**< The clipboard or primary selection changed */

    /* Drag and drop events */
    SDL_EVENT_DROP_FILE        = 0x1000, /**< The system requests a file open */
    SDL_EVENT_DROP_TEXT,                 /**< text/plain drag-and-drop event */
    SDL_EVENT_DROP_BEGIN,                /**< A new set of drops is beginning (NULL filename) */
    SDL_EVENT_DROP_COMPLETE,             /**< Current set of drops is now complete (NULL filename) */
    SDL_EVENT_DROP_POSITION,             /**< Position while moving over the window */

    /* Audio hotplug events */
    SDL_EVENT_AUDIO_DEVICE_ADDED = 0x1100,  /**< A new audio device is available */
    SDL_EVENT_AUDIO_DEVICE_REMOVED,         /**< An audio device has been removed. */
    SDL_EVENT_AUDIO_DEVICE_FORMAT_CHANGED,  /**< An audio device's format has been changed by the system. */

    /* Sensor events */
    SDL_EVENT_SENSOR_UPDATE = 0x1200,     /**< A sensor was updated */

    /* Pressure-sensitive pen events */
    SDL_EVENT_PEN_PROXIMITY_IN = 0x1300,  /**< Pressure-sensitive pen has become available */
    SDL_EVENT_PEN_PROXIMITY_OUT,          /**< Pressure-sensitive pen has become unavailable */
    SDL_EVENT_PEN_DOWN,                   /**< Pressure-sensitive pen touched drawing surface */
    SDL_EVENT_PEN_UP,                     /**< Pressure-sensitive pen stopped touching drawing surface */
    SDL_EVENT_PEN_BUTTON_DOWN,            /**< Pressure-sensitive pen button pressed */
    SDL_EVENT_PEN_BUTTON_UP,              /**< Pressure-sensitive pen button released */
    SDL_EVENT_PEN_MOTION,                 /**< Pressure-sensitive pen is moving on the tablet */
    SDL_EVENT_PEN_AXIS,                   /**< Pressure-sensitive pen angle/pressure/etc changed */

    /* Camera hotplug events */
    SDL_EVENT_CAMERA_DEVICE_ADDED = 0x1400,  /**< A new camera device is available */
    SDL_EVENT_CAMERA_DEVICE_REMOVED,         /**< A camera device has been removed. */
    SDL_EVENT_CAMERA_DEVICE_APPROVED,        /**< A camera device has been approved for use by the user. */
    SDL_EVENT_CAMERA_DEVICE_DENIED,          /**< A camera device has been denied for use by the user. */

    /* Render events */
    SDL_EVENT_RENDER_TARGETS_RESET = 0x2000, /**< The render targets have been reset and their contents need to be updated */
    SDL_EVENT_RENDER_DEVICE_RESET, /**< The device has been reset and all textures need to be recreated */
    SDL_EVENT_RENDER_DEVICE_LOST, /**< The device has been lost and can't be recovered. */

    /* Reserved events for private platforms */
    SDL_EVENT_PRIVATE0 = 0x4000,
    SDL_EVENT_PRIVATE1,
    SDL_EVENT_PRIVATE2,
    SDL_EVENT_PRIVATE3,

    /* Internal events */
    SDL_EVENT_POLL_SENTINEL = 0x7F00, /**< Signals the end of an event poll cycle */

    /** Events SDL_EVENT_USER through SDL_EVENT_LAST are for your use,
     *  and should be allocated with SDL_RegisterEvents()
     */
    SDL_EVENT_USER    = 0x8000,

    /**
     *  This last event is only for bounding internal arrays
     */
    SDL_EVENT_LAST    = 0xFFFF,

    /* This just makes sure the enum is the size of uint */
    SDL_EVENT_ENUM_PADDING = 0x7FFFFFFF

} 

/**
 * Fields shared by every event
 *
 * \since This struct is available since SDL 3.2.0.
 */
struct SDL_CommonEvent
{
    uint type;        /**< Event type, shared with all events, uint to cover user events which are not in the SDL_EventType enumeration */
    uint reserved;
    ulong timestamp;   /**< In nanoseconds, populated using SDL_GetTicksNS() */
} 

/**
 * Display state change event data (event.display.*)
 *
 * \since This struct is available since SDL 3.2.0.
 */
struct SDL_DisplayEvent
{
    SDL_EventType type; /**< SDL_DISPLAYEVENT_* */
    uint reserved;
    ulong timestamp;   /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_DisplayID displayID;/**< The associated display */
    int data1;       /**< event dependent data */
    int data2;       /**< event dependent data */
} 

/**
 * Window state change event data (event.window.*)
 *
 * \since This struct is available since SDL 3.2.0.
 */
struct SDL_WindowEvent
{
    SDL_EventType type; /**< SDL_EVENT_WINDOW_* */
    uint reserved;
    ulong timestamp;   /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_WindowID windowID; /**< The associated window */
    int data1;       /**< event dependent data */
    int data2;       /**< event dependent data */
} 

/**
 * Keyboard device event structure (event.kdevice.*)
 *
 * \since This struct is available since SDL 3.2.0.
 */
struct SDL_KeyboardDeviceEvent
{
    SDL_EventType type; /**< SDL_EVENT_KEYBOARD_ADDED or SDL_EVENT_KEYBOARD_REMOVED */
    uint reserved;
    ulong timestamp;   /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_KeyboardID which;   /**< The keyboard instance id */
} 

/**
 * Keyboard button event structure (event.key.*)
 *
 * The `key` is the base SDL_Keycode generated by pressing the `scancode`
 * using the current keyboard layout, applying any options specified in
 * SDL_HINT_KEYCODE_OPTIONS. You can get the SDL_Keycode corresponding to the
 * event scancode and modifiers directly from the keyboard layout, bypassing
 * SDL_HINT_KEYCODE_OPTIONS, by calling SDL_GetKeyFromScancode().
 *
 * \since This struct is available since SDL 3.2.0.
 *
 * \sa SDL_GetKeyFromScancode
 * \sa SDL_HINT_KEYCODE_OPTIONS
 */
struct SDL_KeyboardEvent
{
    SDL_EventType type;     /**< SDL_EVENT_KEY_DOWN or SDL_EVENT_KEY_UP */
    uint reserved;
    ulong timestamp;       /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_WindowID windowID;  /**< The window with keyboard focus, if any */
    SDL_KeyboardID which;   /**< The keyboard instance id, or 0 if unknown or virtual */
    SDL_Scancode scancode;  /**< SDL physical key code */
    SDL_Keycode key;        /**< SDL virtual key code */
    SDL_Keymod mod;         /**< current key modifiers */
    ushort raw;             /**< The platform dependent scancode for this event */
    bool down;              /**< true if the key is pressed */
    bool repeat;            /**< true if this is a key repeat */
}

/**
 * Keyboard text editing event structure (event.edit.*)
 *
 * The start cursor is the position, in UTF-8 characters, where new typing
 * will be inserted into the editing text. The length is the number of UTF-8
 * characters that will be replaced by new typing.
 *
 * \since This struct is available since SDL 3.2.0.
 */
struct SDL_TextEditingEvent
{
    SDL_EventType type;         /**< SDL_EVENT_TEXT_EDITING */
    uint reserved;
    ulong timestamp;           /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_WindowID windowID;      /**< The window with keyboard focus, if any */
    const char *text;           /**< The editing text */
    int start;               /**< The start cursor of selected editing text, or -1 if not set */
    int length;              /**< The length of selected editing text, or -1 if not set */
}

/**
 * Keyboard IME candidates event structure (event.edit_candidates.*)
 *
 * \since This struct is available since SDL 3.2.0.
 */
struct SDL_TextEditingCandidatesEvent
{
    SDL_EventType type;         /**< SDL_EVENT_TEXT_EDITING_CANDIDATES */
    uint reserved;
    ulong timestamp;           /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_WindowID windowID;      /**< The window with keyboard focus, if any */
		// TODO This line below might be wrong
    const char* candidates;    /**< The list of candidates, or NULL if there are no candidates available */
    int num_candidates;      /**< The number of strings in `candidates` */
    int selected_candidate;  /**< The index of the selected candidate, or -1 if no candidate is selected */
    bool horizontal;          /**< true if the list is horizontal, false if it's vertical */
    ubyte padding1;
    ubyte padding2;
    ubyte padding3;
}

/**
 * Keyboard text input event structure (event.text.*)
 *
 * This event will never be delivered unless text input is enabled by calling
 * SDL_StartTextInput(). Text input is disabled by default!
 *
 * \since This struct is available since SDL 3.2.0.
 *
 * \sa SDL_StartTextInput
 * \sa SDL_StopTextInput
 */
struct SDL_TextInputEvent
{
    SDL_EventType type; /**< SDL_EVENT_TEXT_INPUT */
    uint reserved;
    ulong timestamp;   /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_WindowID windowID; /**< The window with keyboard focus, if any */
    const char *text;   /**< The input text, UTF-8 encoded */
} 

/**
 * Mouse device event structure (event.mdevice.*)
 *
 * \since This struct is available since SDL 3.2.0.
 */
struct SDL_MouseDeviceEvent
{
    SDL_EventType type; /**< SDL_EVENT_MOUSE_ADDED or SDL_EVENT_MOUSE_REMOVED */
    uint reserved;
    ulong timestamp;   /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_MouseID which;  /**< The mouse instance id */
} 

/**
 * Mouse motion event structure (event.motion.*)
 *
 * \since This struct is available since SDL 3.2.0.
 */
struct SDL_MouseMotionEvent
{
    SDL_EventType type; /**< SDL_EVENT_MOUSE_MOTION */
    uint reserved;
    ulong timestamp;   /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_WindowID windowID; /**< The window with mouse focus, if any */
    SDL_MouseID which;  /**< The mouse instance id in relative mode, SDL_TOUCH_MOUSEID for touch events, or 0 */
    SDL_MouseButtonFlags state;       /**< The current button state */
    float x;            /**< X coordinate, relative to window */
    float y;            /**< Y coordinate, relative to window */
    float xrel;         /**< The relative motion in the X direction */
    float yrel;         /**< The relative motion in the Y direction */
} 

/**
 * Mouse button event structure (event.button.*)
 *
 * \since This struct is available since SDL 3.2.0.
 */
struct SDL_MouseButtonEvent
{
    SDL_EventType type; /**< SDL_EVENT_MOUSE_BUTTON_DOWN or SDL_EVENT_MOUSE_BUTTON_UP */
    uint reserved;
    ulong timestamp;   /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_WindowID windowID; /**< The window with mouse focus, if any */
    SDL_MouseID which;  /**< The mouse instance id in relative mode, SDL_TOUCH_MOUSEID for touch events, or 0 */
    ubyte button;       /**< The mouse button index */
    bool down;          /**< true if the button is pressed */
    ubyte clicks;       /**< 1 for single-click, 2 for double-click, etc. */
    ubyte padding;
    float x;            /**< X coordinate, relative to window */
    float y;            /**< Y coordinate, relative to window */
} 

/**
 * Mouse wheel event structure (event.wheel.*)
 *
 * \since This struct is available since SDL 3.2.0.
 */
struct SDL_MouseWheelEvent
{
    SDL_EventType type; /**< SDL_EVENT_MOUSE_WHEEL */
    uint reserved;
    ulong timestamp;   /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_WindowID windowID; /**< The window with mouse focus, if any */
    SDL_MouseID which;  /**< The mouse instance id in relative mode or 0 */
    float x;            /**< The amount scrolled horizontally, positive to the right and negative to the left */
    float y;            /**< The amount scrolled vertically, positive away from the user and negative toward the user */
    SDL_MouseWheelDirection direction; /**< Set to one of the SDL_MOUSEWHEEL_* defines. When FLIPPED the values in X and Y will be opposite. Multiply by -1 to change them back */
    float mouse_x;      /**< X coordinate, relative to window */
    float mouse_y;      /**< Y coordinate, relative to window */
} 

/**
 * Joystick axis motion event structure (event.jaxis.*)
 *
 * \since This struct is available since SDL 3.2.0.
 */
struct SDL_JoyAxisEvent
{
    SDL_EventType type; /**< SDL_EVENT_JOYSTICK_AXIS_MOTION */
    uint reserved;
    ulong timestamp;   /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_JoystickID which; /**< The joystick instance id */
    ubyte axis;         /**< The joystick axis index */
    ubyte padding1;
    ubyte padding2;
    ubyte padding3;
    short value;       /**< The axis value (range: -32768 to 32767) */
    ushort padding4;
} 

/**
 * Joystick trackball motion event structure (event.jball.*)
 *
 * \since This struct is available since SDL 3.2.0.
 */
struct SDL_JoyBallEvent
{
    SDL_EventType type; /**< SDL_EVENT_JOYSTICK_BALL_MOTION */
    uint reserved;
    ulong timestamp;   /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_JoystickID which; /**< The joystick instance id */
    ubyte ball;         /**< The joystick trackball index */
    ubyte padding1;
    ubyte padding2;
    ubyte padding3;
    short xrel;        /**< The relative motion in the X direction */
    short yrel;        /**< The relative motion in the Y direction */
} 

/**
 * Joystick hat position change event structure (event.jhat.*)
 *
 * \since This struct is available since SDL 3.2.0.
 */
struct SDL_JoyHatEvent
{
    SDL_EventType type; /**< SDL_EVENT_JOYSTICK_HAT_MOTION */
    uint reserved;
    ulong timestamp;   /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_JoystickID which; /**< The joystick instance id */
    ubyte hat;          /**< The joystick hat index */
    ubyte value;        /**< The hat position value.
                         *   \sa SDL_HAT_LEFTUP SDL_HAT_UP SDL_HAT_RIGHTUP
                         *   \sa SDL_HAT_LEFT SDL_HAT_CENTERED SDL_HAT_RIGHT
                         *   \sa SDL_HAT_LEFTDOWN SDL_HAT_DOWN SDL_HAT_RIGHTDOWN
                         *
                         *   Note that zero means the POV is centered.
                         */
    ubyte padding1;
    ubyte padding2;
} 

/**
 * Joystick button event structure (event.jbutton.*)
 *
 * \since This struct is available since SDL 3.2.0.
 */
struct SDL_JoyButtonEvent
{
    SDL_EventType type; /**< SDL_EVENT_JOYSTICK_BUTTON_DOWN or SDL_EVENT_JOYSTICK_BUTTON_UP */
    uint reserved;
    ulong timestamp;   /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_JoystickID which; /**< The joystick instance id */
    ubyte button;       /**< The joystick button index */
    bool down;      /**< true if the button is pressed */
    ubyte padding1;
    ubyte padding2;
} 

/**
 * Joystick device event structure (event.jdevice.*)
 *
 * SDL will send JOYSTICK_ADDED events for devices that are already plugged in
 * during SDL_Init.
 *
 * \since This struct is available since SDL 3.2.0.
 *
 * \sa SDL_GamepadDeviceEvent
 */
struct SDL_JoyDeviceEvent
{
    SDL_EventType type; /**< SDL_EVENT_JOYSTICK_ADDED or SDL_EVENT_JOYSTICK_REMOVED or SDL_EVENT_JOYSTICK_UPDATE_COMPLETE */
    uint reserved;
    ulong timestamp;   /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_JoystickID which;       /**< The joystick instance id */
} 

/**
 * Joystick battery level change event structure (event.jbattery.*)
 *
 * \since This struct is available since SDL 3.2.0.
 */
struct SDL_JoyBatteryEvent
{
    SDL_EventType type; /**< SDL_EVENT_JOYSTICK_BATTERY_UPDATED */
    uint reserved;
    ulong timestamp;   /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_JoystickID which; /**< The joystick instance id */
    SDL_PowerState state; /**< The joystick battery state */
    int percent;          /**< The joystick battery percent charge remaining */
} 

/**
 * Gamepad axis motion event structure (event.gaxis.*)
 *
 * \since This struct is available since SDL 3.2.0.
 */
struct SDL_GamepadAxisEvent
{
    SDL_EventType type; /**< SDL_EVENT_GAMEPAD_AXIS_MOTION */
    uint reserved;
    ulong timestamp;   /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_JoystickID which; /**< The joystick instance id */
    ubyte axis;         /**< The gamepad axis (SDL_GamepadAxis) */
    ubyte padding1;
    ubyte padding2;
    ubyte padding3;
    short value;       /**< The axis value (range: -32768 to 32767) */
    ushort padding4;
} 


/**
 * Gamepad button event structure (event.gbutton.*)
 *
 * \since This struct is available since SDL 3.2.0.
 */
struct SDL_GamepadButtonEvent
{
    SDL_EventType type; /**< SDL_EVENT_GAMEPAD_BUTTON_DOWN or SDL_EVENT_GAMEPAD_BUTTON_UP */
    uint reserved;
    ulong timestamp;   /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_JoystickID which; /**< The joystick instance id */
    ubyte button;       /**< The gamepad button (SDL_GamepadButton) */
    bool down;      /**< true if the button is pressed */
    ubyte padding1;
    ubyte padding2;
} 


/**
 * Gamepad device event structure (event.gdevice.*)
 *
 * Joysticks that are supported gamepads receive both an SDL_JoyDeviceEvent
 * and an SDL_GamepadDeviceEvent.
 *
 * SDL will send GAMEPAD_ADDED events for joysticks that are already plugged
 * in during SDL_Init() and are recognized as gamepads. It will also send
 * events for joysticks that get gamepad mappings at runtime.
 *
 * \since This struct is available since SDL 3.2.0.
 *
 * \sa SDL_JoyDeviceEvent
 */
struct SDL_GamepadDeviceEvent
{
    SDL_EventType type; /**< SDL_EVENT_GAMEPAD_ADDED, SDL_EVENT_GAMEPAD_REMOVED, or SDL_EVENT_GAMEPAD_REMAPPED, SDL_EVENT_GAMEPAD_UPDATE_COMPLETE or SDL_EVENT_GAMEPAD_STEAM_HANDLE_UPDATED */
    uint reserved;
    ulong timestamp;   /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_JoystickID which;       /**< The joystick instance id */
} 

/**
 * Gamepad touchpad event structure (event.gtouchpad.*)
 *
 * \since This struct is available since SDL 3.2.0.
 */
struct SDL_GamepadTouchpadEvent
{
    SDL_EventType type; /**< SDL_EVENT_GAMEPAD_TOUCHPAD_DOWN or SDL_EVENT_GAMEPAD_TOUCHPAD_MOTION or SDL_EVENT_GAMEPAD_TOUCHPAD_UP */
    uint reserved;
    ulong timestamp;   /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_JoystickID which; /**< The joystick instance id */
    int touchpad;    /**< The index of the touchpad */
    int finger;      /**< The index of the finger on the touchpad */
    float x;            /**< Normalized in the range 0...1 with 0 being on the left */
    float y;            /**< Normalized in the range 0...1 with 0 being at the top */
    float pressure;     /**< Normalized in the range 0...1 */
} 

/**
 * Gamepad sensor event structure (event.gsensor.*)
 *
 * \since This struct is available since SDL 3.2.0.
 */
struct SDL_GamepadSensorEvent
{
    SDL_EventType type; /**< SDL_EVENT_GAMEPAD_SENSOR_UPDATE */
    uint reserved;
    ulong timestamp;   /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_JoystickID which; /**< The joystick instance id */
    int sensor;      /**< The type of the sensor, one of the values of SDL_SensorType */
    float[3] data;      /**< Up to 3 values from the sensor, as defined in SDL_sensor.h */
    ulong sensor_timestamp; /**< The timestamp of the sensor reading in nanoseconds, not necessarily synchronized with the system clock */
} 

/**
 * Audio device event structure (event.adevice.*)
 *
 * \since This struct is available since SDL 3.2.0.
 */
struct SDL_AudioDeviceEvent
{
    SDL_EventType type; /**< SDL_EVENT_AUDIO_DEVICE_ADDED, or SDL_EVENT_AUDIO_DEVICE_REMOVED, or SDL_EVENT_AUDIO_DEVICE_FORMAT_CHANGED */
    uint reserved;
    ulong timestamp;   /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_AudioDeviceID which;       /**< SDL_AudioDeviceID for the device being added or removed or changing */
    bool recording; /**< false if a playback device, true if a recording device. */
    ubyte padding1;
    ubyte padding2;
    ubyte padding3;
} 

/**
 * Camera device event structure (event.cdevice.*)
 *
 * \since This struct is available since SDL 3.2.0.
 */
struct SDL_CameraDeviceEvent
{
    SDL_EventType type; /**< SDL_EVENT_CAMERA_DEVICE_ADDED, SDL_EVENT_CAMERA_DEVICE_REMOVED, SDL_EVENT_CAMERA_DEVICE_APPROVED, SDL_EVENT_CAMERA_DEVICE_DENIED */
    uint reserved;
    ulong timestamp;   /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_CameraID which;       /**< SDL_CameraID for the device being added or removed or changing */
} 


/**
 * Renderer event structure (event.render.*)
 *
 * \since This struct is available since SDL 3.2.0.
 */
struct SDL_RenderEvent
{
    SDL_EventType type; /**< SDL_EVENT_RENDER_TARGETS_RESET, SDL_EVENT_RENDER_DEVICE_RESET, SDL_EVENT_RENDER_DEVICE_LOST */
    uint reserved;
    ulong timestamp;   /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_WindowID windowID; /**< The window containing the renderer in question. */
} 


/**
 * Touch finger event structure (event.tfinger.*)
 *
 * Coordinates in this event are normalized. `x` and `y` are normalized to a
 * range between 0.0f and 1.0f, relative to the window, so (0,0) is the top
 * left and (1,1) is the bottom right. Delta coordinates `dx` and `dy` are
 * normalized in the ranges of -1.0f (traversed all the way from the bottom or
 * right to all the way up or left) to 1.0f (traversed all the way from the
 * top or left to all the way down or right).
 *
 * Note that while the coordinates are _normalized_, they are not _clamped_,
 * which means in some circumstances you can get a value outside of this
 * range. For example, a renderer using logical presentation might give a
 * negative value when the touch is in the letterboxing. Some platforms might
 * report a touch outside of the window, which will also be outside of the
 * range.
 *
 * \since This struct is available since SDL 3.2.0.
 */
struct SDL_TouchFingerEvent
{
    SDL_EventType type; /**< SDL_EVENT_FINGER_DOWN, SDL_EVENT_FINGER_UP, SDL_EVENT_FINGER_MOTION, or SDL_EVENT_FINGER_CANCELED */
    uint reserved;
    ulong timestamp;   /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_TouchID touchID; /**< The touch device id */
    SDL_FingerID fingerID;
    float x;            /**< Normalized in the range 0...1 */
    float y;            /**< Normalized in the range 0...1 */
    float dx;           /**< Normalized in the range -1...1 */
    float dy;           /**< Normalized in the range -1...1 */
    float pressure;     /**< Normalized in the range 0...1 */
    SDL_WindowID windowID; /**< The window underneath the finger, if any */
}

/**
 * Pressure-sensitive pen proximity event structure (event.pmotion.*)
 *
 * When a pen becomes visible to the system (it is close enough to a tablet,
 * etc), SDL will send an SDL_EVENT_PEN_PROXIMITY_IN event with the new pen's
 * ID. This ID is valid until the pen leaves proximity again (has been removed
 * from the tablet's area, the tablet has been unplugged, etc). If the same
 * pen reenters proximity again, it will be given a new ID.
 *
 * Note that "proximity" means "close enough for the tablet to know the tool
 * is there." The pen touching and lifting off from the tablet while not
 * leaving the area are handled by SDL_EVENT_PEN_DOWN and SDL_EVENT_PEN_UP.
 *
 * \since This struct is available since SDL 3.2.0.
 */
struct SDL_PenProximityEvent
{
    SDL_EventType type; /**< SDL_EVENT_PEN_PROXIMITY_IN or SDL_EVENT_PEN_PROXIMITY_OUT */
    uint reserved;
    ulong timestamp;   /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_WindowID windowID; /**< The window with pen focus, if any */
    SDL_PenID which;        /**< The pen instance id */
} 

/**
 * Pressure-sensitive pen motion event structure (event.pmotion.*)
 *
 * Depending on the hardware, you may get motion events when the pen is not
 * touching a tablet, for tracking a pen even when it isn't drawing. You
 * should listen for SDL_EVENT_PEN_DOWN and SDL_EVENT_PEN_UP events, or check
 * `pen_state & SDL_PEN_INPUT_DOWN` to decide if a pen is "drawing" when
 * dealing with pen motion.
 *
 * \since This struct is available since SDL 3.2.0.
 */
struct SDL_PenMotionEvent
{
    SDL_EventType type; /**< SDL_EVENT_PEN_MOTION */
    uint reserved;
    ulong timestamp;   /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_WindowID windowID; /**< The window with pen focus, if any */
    SDL_PenID which;        /**< The pen instance id */
    SDL_PenInputFlags pen_state;   /**< Complete pen input state at time of event */
    float x;                /**< X coordinate, relative to window */
    float y;                /**< Y coordinate, relative to window */
} 

/**
 * Pressure-sensitive pen touched event structure (event.ptouch.*)
 *
 * These events come when a pen touches a surface (a tablet, etc), or lifts
 * off from one.
 *
 * \since This struct is available since SDL 3.2.0.
 */
struct SDL_PenTouchEvent
{
    SDL_EventType type;     /**< SDL_EVENT_PEN_DOWN or SDL_EVENT_PEN_UP */
    uint reserved;
    ulong timestamp;       /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_WindowID windowID;  /**< The window with pen focus, if any */
    SDL_PenID which;        /**< The pen instance id */
    SDL_PenInputFlags pen_state;   /**< Complete pen input state at time of event */
    float x;                /**< X coordinate, relative to window */
    float y;                /**< Y coordinate, relative to window */
    bool eraser;        /**< true if eraser end is used (not all pens support this). */
    bool down;          /**< true if the pen is touching or false if the pen is lifted off */
} 

/**
 * Pressure-sensitive pen button event structure (event.pbutton.*)
 *
 * This is for buttons on the pen itself that the user might click. The pen
 * itself pressing down to draw triggers a SDL_EVENT_PEN_DOWN event instead.
 *
 * \since This struct is available since SDL 3.2.0.
 */
struct SDL_PenButtonEvent
{
    SDL_EventType type; /**< SDL_EVENT_PEN_BUTTON_DOWN or SDL_EVENT_PEN_BUTTON_UP */
    uint reserved;
    ulong timestamp;   /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_WindowID windowID; /**< The window with mouse focus, if any */
    SDL_PenID which;        /**< The pen instance id */
    SDL_PenInputFlags pen_state;   /**< Complete pen input state at time of event */
    float x;                /**< X coordinate, relative to window */
    float y;                /**< Y coordinate, relative to window */
    ubyte button;       /**< The pen button index (first button is 1). */
    bool down;      /**< true if the button is pressed */
} 

/**
 * Pressure-sensitive pen pressure / angle event structure (event.paxis.*)
 *
 * You might get some of these events even if the pen isn't touching the
 * tablet.
 *
 * \since This struct is available since SDL 3.2.0.
 */
struct SDL_PenAxisEvent
{
    SDL_EventType type;     /**< SDL_EVENT_PEN_AXIS */
    uint reserved;
    ulong timestamp;       /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_WindowID windowID;  /**< The window with pen focus, if any */
    SDL_PenID which;        /**< The pen instance id */
    SDL_PenInputFlags pen_state;   /**< Complete pen input state at time of event */
    float x;                /**< X coordinate, relative to window */
    float y;                /**< Y coordinate, relative to window */
    SDL_PenAxis axis;       /**< Axis that has changed */
    float value;            /**< New value of axis */
} 

/**
 * An event used to drop text or request a file open by the system
 * (event.drop.*)
 *
 * \since This struct is available since SDL 3.2.0.
 */
struct SDL_DropEvent
{
    SDL_EventType type; /**< SDL_EVENT_DROP_BEGIN or SDL_EVENT_DROP_FILE or SDL_EVENT_DROP_TEXT or SDL_EVENT_DROP_COMPLETE or SDL_EVENT_DROP_POSITION */
    uint reserved;
    ulong timestamp;   /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_WindowID windowID;    /**< The window that was dropped on, if any */
    float x;            /**< X coordinate, relative to window (not on begin) */
    float y;            /**< Y coordinate, relative to window (not on begin) */
    const char *source; /**< The source app that sent this drop event, or NULL if that isn't available */
    const char *data;   /**< The text for SDL_EVENT_DROP_TEXT and the file name for SDL_EVENT_DROP_FILE, NULL for other events */
} 

/**
 * An event triggered when the clipboard contents have changed
 * (event.clipboard.*)
 *
 * \since This struct is available since SDL 3.2.0.
 */
struct SDL_ClipboardEvent
{
    SDL_EventType type; /**< SDL_EVENT_CLIPBOARD_UPDATE */
    uint reserved;
    ulong timestamp;   /**< In nanoseconds, populated using SDL_GetTicksNS() */
    bool owner;         /**< are we owning the clipboard (internal update) */
    int num_mime_types;   /**< number of mime types */
    const char **mime_types; /**< current mime types */
} 

/**
 * Sensor event structure (event.sensor.*)
 *
 * \since This struct is available since SDL 3.2.0.
 */
struct SDL_SensorEvent
{
    SDL_EventType type; /**< SDL_EVENT_SENSOR_UPDATE */
    uint reserved;
    ulong timestamp;   /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_SensorID which; /**< The instance ID of the sensor */
    float[6] data;      /**< Up to 6 values from the sensor - additional values can be queried using SDL_GetSensorData() */
    ulong sensor_timestamp; /**< The timestamp of the sensor reading in nanoseconds, not necessarily synchronized with the system clock */
} 

/**
 * The "quit requested" event
 *
 * \since This struct is available since SDL 3.2.0.
 */
struct SDL_QuitEvent
{
    SDL_EventType type; /**< SDL_EVENT_QUIT */
    uint reserved;
    ulong timestamp;   /**< In nanoseconds, populated using SDL_GetTicksNS() */
} 

/**
 * A user-defined event type (event.user.*)
 *
 * This event is unique; it is never created by SDL, but only by the
 * application. The event can be pushed onto the event queue using
 * SDL_PushEvent(). The contents of the structure members are completely up to
 * the programmer; the only requirement is that '''type''' is a value obtained
 * from SDL_RegisterEvents().
 *
 * \since This struct is available since SDL 3.2.0.
 */
struct SDL_UserEvent
{
    uint type;        /**< SDL_EVENT_USER through SDL_EVENT_LAST-1, uint because these are not in the SDL_EventType enumeration */
    uint reserved;
    ulong timestamp;   /**< In nanoseconds, populated using SDL_GetTicksNS() */
    SDL_WindowID windowID; /**< The associated window if any */
    int code;        /**< User defined event code */
    void *data1;        /**< User defined data pointer */
    void *data2;        /**< User defined data pointer */
} 

union SDL_Event
{

	uint type;                            /**< Event type, shared with all events, Uint32 to cover user events which are not in the SDL_EventType enumeration */
    SDL_CommonEvent common;                 /**< Common event data */
    SDL_DisplayEvent display;               /**< Display event data */
    SDL_WindowEvent window;                 /**< Window event data */
    SDL_KeyboardDeviceEvent kdevice;        /**< Keyboard device change event data */
    SDL_KeyboardEvent key;                  /**< Keyboard event data */
    SDL_TextEditingEvent edit;              /**< Text editing event data */
    SDL_TextEditingCandidatesEvent edit_candidates; /**< Text editing candidates event data */
    SDL_TextInputEvent text;                /**< Text input event data */
    SDL_MouseDeviceEvent mdevice;           /**< Mouse device change event data */
    SDL_MouseMotionEvent motion;            /**< Mouse motion event data */
    SDL_MouseButtonEvent button;            /**< Mouse button event data */
    SDL_MouseWheelEvent wheel;              /**< Mouse wheel event data */
    SDL_JoyDeviceEvent jdevice;             /**< Joystick device change event data */
    SDL_JoyAxisEvent jaxis;                 /**< Joystick axis event data */
    SDL_JoyBallEvent jball;                 /**< Joystick ball event data */
    SDL_JoyHatEvent jhat;                   /**< Joystick hat event data */
    SDL_JoyButtonEvent jbutton;             /**< Joystick button event data */
    SDL_JoyBatteryEvent jbattery;           /**< Joystick battery event data */
    SDL_GamepadDeviceEvent gdevice;         /**< Gamepad device event data */
    SDL_GamepadAxisEvent gaxis;             /**< Gamepad axis event data */
    SDL_GamepadButtonEvent gbutton;         /**< Gamepad button event data */
    SDL_GamepadTouchpadEvent gtouchpad;     /**< Gamepad touchpad event data */
    SDL_GamepadSensorEvent gsensor;         /**< Gamepad sensor event data */
    SDL_AudioDeviceEvent adevice;           /**< Audio device event data */
    SDL_CameraDeviceEvent cdevice;          /**< Camera device event data */
    SDL_SensorEvent sensor;                 /**< Sensor event data */
    SDL_QuitEvent quit;                     /**< Quit request event data */
    SDL_UserEvent user;                     /**< Custom event data */
    SDL_TouchFingerEvent tfinger;           /**< Touch finger event data */
    SDL_PenProximityEvent pproximity;       /**< Pen proximity event data */
    SDL_PenTouchEvent ptouch;               /**< Pen tip touching event data */
    SDL_PenMotionEvent pmotion;             /**< Pen motion event data */
    SDL_PenButtonEvent pbutton;             /**< Pen button event data */
    SDL_PenAxisEvent paxis;                 /**< Pen axis event data */
    SDL_RenderEvent render;                 /**< Render event data */
    SDL_DropEvent drop;                     /**< Drag and drop event data */
    SDL_ClipboardEvent clipboard;           /**< Clipboard event data */

    /* This is necessary for ABI compatibility between Visual C++ and GCC.
       Visual C++ will respect the push pack pragma and use 52 bytes (size of
       SDL_TextEditingEvent, the largest structure for 32-bit and 64-bit
       architectures) for this union, and GCC will use the alignment of the
       largest datatype within the union, which is 8 bytes on 64-bit
       architectures.

       So... we'll add padding to force the size to be the same for both.

       On architectures where pointers are 16 bytes, this needs rounding up to
       the next multiple of 16, 64, and on architectures where pointers are
       even larger the size of SDL_UserEvent will dominate as being 3 pointers.
    */
    ubyte[128] padding;
}




enum SDL_ALPHA_OPAQUE = 255;
enum SDL_ALPHA_TRANSPARENT = 0;


struct SDL_BlitMap;
struct SDL_Surface
{
		uint flags;               /**< Read-only */
		SDL_PixelFormat *format;    /**< Read-only */
		int w, h;                   /**< Read-only */
		int pitch;                  /**< Read-only */
		void *pixels;               /**< Read-write */

		/** Application data associated with the surface */
		void *userdata;             /**< Read-write */

		/** information needed for surfaces requiring locks */
		int locked;                 /**< Read-only */

		/** list of BlitMap that hold a reference to this surface */
		void *list_blitmap;         /**< Private */

		/** clipping information */
		SDL_Rect clip_rect;         /**< Read-only */

		/** info for fast blit mapping to other surfaces */
		SDL_BlitMap *map;           /**< Private */

		/** Reference count -- used when freeing surface */
		int refcount;               /**< Read-mostly */
}

enum SDL_BlendMode
{
		SDL_BLENDMODE_NONE = 0x00000000,     /**< no blending
																					 dstRGBA = srcRGBA */
		SDL_BLENDMODE_BLEND = 0x00000001,    /**< alpha blending
																					 dstRGB = (srcRGB * srcA) + (dstRGB * (1-srcA))
																					 dstA = srcA + (dstA * (1-srcA)) */
		SDL_BLENDMODE_ADD = 0x00000002,      /**< additive blending
																					 dstRGB = (srcRGB * srcA) + dstRGB
																					 dstA = dstA */
		SDL_BLENDMODE_MOD = 0x00000004,      /**< color modulate
																					 dstRGB = srcRGB * dstRGB
																					 dstA = dstA */
		SDL_BLENDMODE_MUL = 0x00000008,      /**< color multiply
																					 dstRGB = (srcRGB * dstRGB) + (dstRGB * (1-srcA))
																					 dstA = dstA */
		SDL_BLENDMODE_INVALID = 0x7FFFFFFF

				/* Additional custom blend modes can be returned by SDL_ComposeCustomBlendMode() */
}
alias SDL_BLENDMODE_ADD = SDL_BlendMode.SDL_BLENDMODE_ADD;

auto SDL_BUTTON(int X) {return (1 << (X-1));}
enum SDL_BUTTON_LEFT   = 1;
enum SDL_BUTTON_MIDDLE = 2;
enum SDL_BUTTON_RIGHT  = 3;
enum SDL_BUTTON_X1     = 4;
enum SDL_BUTTON_X2     = 5;
// TODO
//SDL_BUTTON_LMASK    SDL_BUTTON(SDL_BUTTON_LEFT)
//SDL_BUTTON_MMASK    SDL_BUTTON(SDL_BUTTON_MIDDLE)
//SDL_BUTTON_RMASK    SDL_BUTTON(SDL_BUTTON_RIGHT)
//SDL_BUTTON_X1MASK   SDL_BUTTON(SDL_BUTTON_X1)
//SDL_BUTTON_X2MASK   SDL_BUTTON(SDL_BUTTON_X2)

// C Functions
extern(C){
		bool SDL_Init(SDL_InitFlags flags);
		void SDL_Quit();

		void SDL_Delay(uint);
		SDL_Window* SDL_CreateWindow(const char *title, int w, int h, SDL_WindowFlags flags);
		void SDL_DestroyWindow(SDL_Window * window);

		bool SDL_PollEvent(SDL_Event* event);

		SDL_Renderer * SDL_CreateRenderer(SDL_Window * window,  const char* name);
		void SDL_DestroyRenderer(SDL_Renderer * renderer);
		int SDL_RenderClear(SDL_Renderer * renderer);
		int SDL_SetRenderDrawColor(SDL_Renderer * renderer, ubyte r, ubyte g, ubyte b, ubyte a);
		bool SDL_RenderLine(SDL_Renderer *renderer, float x1, float y1, float x2, float y2);

		void SDL_RenderPresent(SDL_Renderer * renderer);
		int SDL_RenderTexture(SDL_Renderer * renderer, SDL_Texture * texture, const SDL_FRect * srcrect, const SDL_FRect * dstrect);
		bool SDL_RenderRect(SDL_Renderer *renderer, const SDL_FRect *rect);


		SDL_Texture * SDL_CreateTextureFromSurface(SDL_Renderer * renderer, SDL_Surface * surface);
		void SDL_DestroyTexture(SDL_Texture * texture);

		void SDL_DestroySurface(SDL_Surface * surface);
		bool SDL_SetSurfaceColorKey(SDL_Surface *surface, bool enabled, uint key);

		uint SDL_MapRGB(const SDL_PixelFormat * format, ubyte r, ubyte g, ubyte b);
		int SDL_SetTextureBlendMode(SDL_Texture * texture, SDL_BlendMode blendMode);

		SDL_Surface* SDL_LoadBMP(const char* file);
//		SDL_Surface* SDL_LoadBMP_RW(SDL_RWops * src,  int freesrc);
//		auto SDL_LoadBMP(const char* file) { return SDL_LoadBMP_IO(SDL_IOStream* s(file, "rb"), 1); }
//		SDL_RWops* SDL_RWFromFile(const char *file, const char *mode);
}
