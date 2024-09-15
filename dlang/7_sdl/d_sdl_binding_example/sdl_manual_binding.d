// Struct prototype 
struct SDL_Window;
struct SDL_RWops;
struct SDL_Renderer;
struct SDL_PixelFormat;

struct SDL_Rect
{
    int x, y;
    int w, h;
}
struct SDL_Texture;

struct SDL_CommonEvent
{
    uint type;
    uint timestamp;
}
struct SDL_DisplayEvent
{
    uint type;        /**< SDL_DISPLAYEVENT */
    uint timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
    uint display;     /**< The associated display index */
    ubyte event;        /**< SDL_DisplayEventID */
    ubyte padding1;
    ubyte padding2;
    ubyte padding3;
    int data1;       /**< event dependent data */
}
struct SDL_WindowEvent
{
    int type;        /**< SDL_WINDOWEVENT */
    int timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
    int windowID;    /**< The associated window */
    ubyte event;        /**< SDL_WindowEventID */
    ubyte padding1;
    ubyte padding2;
    ubyte padding3;
    int data1;       /**< event dependent data */
    int data2;       /**< event dependent data */
}
struct SDL_KeyboardEvent
{
    uint type;        /**< SDL_KEYDOWN or SDL_KEYUP */
    uint timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
    uint windowID;    /**< The window with keyboard focus, if any */
    ubyte state;        /**< SDL_PRESSED or SDL_RELEASED */
    ubyte repeat;       /**< Non-zero if this is a key repeat */
    ubyte padding2;
    ubyte padding3;
    SDL_Keysym keysym;  /**< The key that was pressed or released */
}
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

enum SDL_TEXTEDITINGEVENT_TEXT_SIZE =(32);
enum SDL_TEXTINPUTEVENT_TEXT_SIZE=   (32);

alias SDL_JoystickID = int;
struct SDL_TextEditingEvent
{
    uint type;                                /**< SDL_TEXTEDITING */
    uint timestamp;                           /**< In milliseconds, populated using SDL_GetTicks() */
    uint windowID;                            /**< The window with keyboard focus, if any */
    char[SDL_TEXTEDITINGEVENT_TEXT_SIZE] text;  /**< The editing text */
    int start;                               /**< The start cursor of selected editing text */
    int length;                              /**< The length of selected editing text */
}
struct SDL_TextEditingExtEvent
{
    uint type;                                /**< SDL_TEXTEDITING_EXT */
    uint timestamp;                           /**< In milliseconds, populated using SDL_GetTicks() */
    uint windowID;                            /**< The window with keyboard focus, if any */
    char* text;                                 /**< The editing text, which should be freed with SDL_free(), and will not be NULL */
    int start;                               /**< The start cursor of selected editing text */
    int length;                              /**< The length of selected editing text */
}
struct SDL_TextInputEvent
{
    uint type;                              /**< SDL_TEXTINPUT */
    uint timestamp;                         /**< In milliseconds, populated using SDL_GetTicks() */
    uint windowID;                          /**< The window with keyboard focus, if any */
    char[SDL_TEXTINPUTEVENT_TEXT_SIZE] text;  /**< The input text; UTF-8 encoded. */
}
struct SDL_MouseMotionEvent
{
    uint type;        /**< SDL_MOUSEMOTION */
    uint timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
    uint windowID;    /**< The window with mouse focus, if any */
    uint which;       /**< The mouse instance id, or SDL_TOUCH_MOUSEID */
    uint state;       /**< The current button state */
    int x;           /**< X coordinate, relative to window */
    int y;           /**< Y coordinate, relative to window */
    int xrel;        /**< The relative motion in the X direction */
    int yrel;        /**< The relative motion in the Y direction */
}
struct SDL_MouseButtonEvent
{
    uint type;        /**< SDL_MOUSEBUTTONDOWN or SDL_MOUSEBUTTONUP */
    uint timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
    uint windowID;    /**< The window with mouse focus, if any */
    uint which;       /**< The mouse instance id, or SDL_TOUCH_MOUSEID */
    ubyte button;       /**< The mouse button index */
    ubyte state;        /**< SDL_PRESSED or SDL_RELEASED */
    ubyte clicks;       /**< 1 for single-click, 2 for double-click, etc. */
    ubyte padding1;
    int x;           /**< X coordinate, relative to window */
    int y;           /**< Y coordinate, relative to window */
}
struct SDL_MouseWheelEvent
{
    uint type;        /**< SDL_MOUSEWHEEL */
    uint timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
    uint windowID;    /**< The window with mouse focus, if any */
    uint which;       /**< The mouse instance id, or SDL_TOUCH_MOUSEID */
    int x;           /**< The amount scrolled horizontally, positive to the right and negative to the left */
    int y;           /**< The amount scrolled vertically, positive away from the user and negative toward the user */
    uint direction;   /**< Set to one of the SDL_MOUSEWHEEL_* defines. When FLIPPED the values in X and Y will be opposite. Multiply by -1 to change them back */
    float preciseX;     /**< The amount scrolled horizontally, positive to the right and negative to the left, with float precision (added in 2.0.18) */
    float preciseY;     /**< The amount scrolled vertically, positive away from the user and negative toward the user, with float precision (added in 2.0.18) */
    int mouseX;      /**< X coordinate, relative to window (added in 2.26.0) */
    int mouseY;      /**< Y coordinate, relative to window (added in 2.26.0) */
}
struct SDL_JoyAxisEvent
{
    uint type;        /**< SDL_JOYAXISMOTION */
    uint timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
    SDL_JoystickID which; /**< The joystick instance id */
    ubyte axis;         /**< The joystick axis index */
    ubyte padding1;
    ubyte padding2;
    ubyte padding3;
    short value;       /**< The axis value (range: -32768 to 32767) */
    ushort padding4;
}
struct SDL_JoyBallEvent
{
    uint type;        /**< SDL_JOYBALLMOTION */
    uint timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
    SDL_JoystickID which; /**< The joystick instance id */
    ubyte ball;         /**< The joystick trackball index */
    ubyte padding1;
    ubyte padding2;
    ubyte padding3;
    short xrel;        /**< The relative motion in the X direction */
    short yrel;        /**< The relative motion in the Y direction */
}
struct SDL_JoyHatEvent
{
    uint type;        /**< SDL_JOYHATMOTION */
    uint timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
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
struct SDL_JoyButtonEvent
{
    uint type;        /**< SDL_JOYBUTTONDOWN or SDL_JOYBUTTONUP */
    uint timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
    SDL_JoystickID which; /**< The joystick instance id */
    ubyte button;       /**< The joystick button index */
    ubyte state;        /**< SDL_PRESSED or SDL_RELEASED */
    ubyte padding1;
    ubyte padding2;
}
struct SDL_JoyDeviceEvent
{
    uint type;        /**< SDL_JOYDEVICEADDED or SDL_JOYDEVICEREMOVED */
    uint timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
    int which;       /**< The joystick device index for the ADDED event, instance id for the REMOVED event */
}
enum SDL_JoystickPowerLevel
{                                                                                                                       
     SDL_JOYSTICK_POWER_UNKNOWN = -1,                                                                                    
     SDL_JOYSTICK_POWER_EMPTY,   /* <= 5% */                                                                             
     SDL_JOYSTICK_POWER_LOW,     /* <= 20% */                                                                            
     SDL_JOYSTICK_POWER_MEDIUM,  /* <= 70% */                                                                            
     SDL_JOYSTICK_POWER_FULL,    /* <= 100% */                                                                           
     SDL_JOYSTICK_POWER_WIRED,                                                                                           
     SDL_JOYSTICK_POWER_MAX                                                                                              
} 
struct SDL_JoyBatteryEvent
{
    uint type;        /**< SDL_JOYBATTERYUPDATED */
    uint timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
    SDL_JoystickID which; /**< The joystick instance id */
    SDL_JoystickPowerLevel level; /**< The joystick battery level */
}
struct SDL_ControllerAxisEvent
{
    uint type;        /**< SDL_CONTROLLERAXISMOTION */
    uint timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
    SDL_JoystickID which; /**< The joystick instance id */
    ubyte axis;         /**< The controller axis (SDL_GameControllerAxis) */
    ubyte padding1;
    ubyte padding2;
    ubyte padding3;
    short value;       /**< The axis value (range: -32768 to 32767) */
    ushort padding4;
}
struct SDL_ControllerButtonEvent
{
    uint type;        /**< SDL_CONTROLLERBUTTONDOWN or SDL_CONTROLLERBUTTONUP */
    uint timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
    SDL_JoystickID which; /**< The joystick instance id */
    ubyte button;       /**< The controller button (SDL_GameControllerButton) */
    ubyte state;        /**< SDL_PRESSED or SDL_RELEASED */
    ubyte padding1;
    ubyte padding2;
}
struct SDL_ControllerDeviceEvent
{
    uint type;        /**< SDL_CONTROLLERDEVICEADDED, SDL_CONTROLLERDEVICEREMOVED, SDL_CONTROLLERDEVICEREMAPPED, or SDL_CONTROLLERSTEAMHANDLEUPDATED */
    uint timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
    int which;       /**< The joystick device index for the ADDED event, instance id for the REMOVED or REMAPPED event */
}
struct SDL_ControllerTouchpadEvent
{
    uint type;        /**< SDL_CONTROLLERTOUCHPADDOWN or SDL_CONTROLLERTOUCHPADMOTION or SDL_CONTROLLERTOUCHPADUP */
    uint timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
    SDL_JoystickID which; /**< The joystick instance id */
    int touchpad;    /**< The index of the touchpad */
    int finger;      /**< The index of the finger on the touchpad */
    float x;            /**< Normalized in the range 0...1 with 0 being on the left */
    float y;            /**< Normalized in the range 0...1 with 0 being at the top */
    float pressure;     /**< Normalized in the range 0...1 */
}

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

struct SDL_ControllerSensorEvent
{
    uint type;        /**< SDL_CONTROLLERSENSORUPDATE */
    uint timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
    SDL_JoystickID which; /**< The joystick instance id */
    int sensor;      /**< The type of the sensor, one of the values of SDL_SensorType */
    float[3] data;      /**< Up to 3 values from the sensor, as defined in SDL_sensor.h */
    ulong timestamp_us; /**< The timestamp of the sensor reading in microseconds, if the hardware provides this information. */
}
struct SDL_AudioDeviceEvent
{
    uint type;        /**< SDL_AUDIODEVICEADDED, or SDL_AUDIODEVICEREMOVED */
    uint timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
    uint which;       /**< The audio device index for the ADDED event (valid until next SDL_GetNumAudioDevices() call), SDL_AudioDeviceID for the REMOVED event */
    ubyte iscapture;    /**< zero if an output device, non-zero if a capture device. */
    ubyte padding1;
    ubyte padding2;
    ubyte padding3;
}
struct SDL_SensorEvent
{
    uint type;        /**< SDL_SENSORUPDATE */
    uint timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
    int which;       /**< The instance ID of the sensor */
    float[6] data;      /**< Up to 6 values from the sensor - additional values can be queried using SDL_SensorGetData() */
    ulong timestamp_us; /**< The timestamp of the sensor reading in microseconds, if the hardware provides this information. */
}
struct SDL_QuitEvent
{
    uint type;        /**< SDL_QUIT */
    uint timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
}
struct SDL_UserEvent
{
    uint type;        /**< SDL_USEREVENT through SDL_LASTEVENT-1 */
    uint timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
    uint windowID;    /**< The associated window if any */
    int code;        /**< User defined event code */
    void *data1;        /**< User defined data pointer */
    void *data2;        /**< User defined data pointer */
}
//struct SDL_SysWMEvent
//{
//    uint type;        /**< SDL_SYSWMEVENT */
//    uint timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
//    SDL_SysWMmsg *msg;  /**< driver dependent data, defined in SDL_syswm.h */
//}
alias SDL_TouchID = long;
alias SDL_FingerID= long;
struct SDL_TouchFingerEvent
{
    uint type;        /**< SDL_FINGERMOTION or SDL_FINGERDOWN or SDL_FINGERUP */
    uint timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
    SDL_TouchID touchId; /**< The touch device id */
    SDL_FingerID fingerId;
    float x;            /**< Normalized in the range 0...1 */
    float y;            /**< Normalized in the range 0...1 */
    float dx;           /**< Normalized in the range -1...1 */
    float dy;           /**< Normalized in the range -1...1 */
    float pressure;     /**< Normalized in the range 0...1 */
    uint windowID;    /**< The window underneath the finger, if any */
}
struct SDL_MultiGestureEvent
{
    uint type;        /**< SDL_MULTIGESTURE */
    uint timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
    SDL_TouchID touchId; /**< The touch device id */
    float dTheta;
    float dDist;
    float x;
    float y;
    ushort numFingers;
    ushort padding;
}
alias SDL_GestureID = long;
struct SDL_DollarGestureEvent
{
    uint type;        /**< SDL_DOLLARGESTURE or SDL_DOLLARRECORD */
    uint timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
    SDL_TouchID touchId; /**< The touch device id */
    SDL_GestureID gestureId;
    uint numFingers;
    float error;
    float x;            /**< Normalized center of gesture */
    float y;            /**< Normalized center of gesture */
}
struct SDL_DropEvent
{
    uint type;        /**< SDL_DROPBEGIN or SDL_DROPFILE or SDL_DROPTEXT or SDL_DROPCOMPLETE */
    uint timestamp;   /**< In milliseconds, populated using SDL_GetTicks() */
    char *file;         /**< The file name, which should be freed with SDL_free(), is NULL on begin/complete */
    uint windowID;    /**< The window that was dropped on, if any */
}

union SDL_Event
{
    uint type;                            /**< Event type, shared with all events */
    SDL_CommonEvent common;                 /**< Common event data */
    SDL_DisplayEvent display;               /**< Display event data */
    SDL_WindowEvent window;                 /**< Window event data */
    SDL_KeyboardEvent key;                  /**< Keyboard event data */
    SDL_TextEditingEvent edit;              /**< Text editing event data */
    SDL_TextEditingExtEvent editExt;        /**< Extended text editing event data */
    SDL_TextInputEvent text;                /**< Text input event data */
    SDL_MouseMotionEvent motion;            /**< Mouse motion event data */
    SDL_MouseButtonEvent button;            /**< Mouse button event data */
    SDL_MouseWheelEvent wheel;              /**< Mouse wheel event data */
    SDL_JoyAxisEvent jaxis;                 /**< Joystick axis event data */
    SDL_JoyBallEvent jball;                 /**< Joystick ball event data */
    SDL_JoyHatEvent jhat;                   /**< Joystick hat event data */
    SDL_JoyButtonEvent jbutton;             /**< Joystick button event data */
    SDL_JoyDeviceEvent jdevice;             /**< Joystick device change event data */
    SDL_JoyBatteryEvent jbattery;           /**< Joystick battery event data */
    SDL_ControllerAxisEvent caxis;          /**< Game Controller axis event data */
    SDL_ControllerButtonEvent cbutton;      /**< Game Controller button event data */
    SDL_ControllerDeviceEvent cdevice;      /**< Game Controller device event data */
    SDL_ControllerTouchpadEvent ctouchpad;  /**< Game Controller touchpad event data */
    SDL_ControllerSensorEvent csensor;      /**< Game Controller sensor event data */
    SDL_AudioDeviceEvent adevice;           /**< Audio device event data */
    SDL_SensorEvent sensor;                 /**< Sensor event data */
    SDL_QuitEvent quit;                     /**< Quit request event data */
    SDL_UserEvent user;                     /**< Custom event data */
//TODO    //SDL_SysWMEvent syswm;                   /**< System dependent window event data */
    SDL_TouchFingerEvent tfinger;           /**< Touch finger event data */
    SDL_MultiGestureEvent mgesture;         /**< Gesture event data */
    SDL_DollarGestureEvent dgesture;        /**< Gesture event data */
    SDL_DropEvent drop;                     /**< Drag and drop event data */

    /* This is necessary for ABI compatibility between Visual C++ and GCC.
       Visual C++ will respect the push pack pragma and use 52 bytes (size of
       SDL_TextEditingEvent, the largest structure for 32-bit and 64-bit
       architectures) for this union, and GCC will use the alignment of the
       largest datatype within the union, which is 8 bytes on 64-bit
       architectures.

       So... we'll add padding to force the size to be 56 bytes for both.

       On architectures where pointers are 16 bytes, this needs rounding up to
       the next multiple of 16, 64, and on architectures where pointers are
       even larger the size of SDL_UserEvent will dominate as being 3 pointers.
    */
    ubyte [(void *).sizeof <= 8 ? 56 : (void *).sizeof == 16 ? 64 : 3 * (void *).sizeof] padding;
} ;


enum 
{
    SDL_FIRSTEVENT     = 0,     /**< Unused (do not remove) */
    /* Application events */
    SDL_QUIT           = 0x100, /**< User-requested quit */
    /* These application events have special meaning on iOS, see README-ios.md for details */
    SDL_APP_TERMINATING,        /**< The application is being terminated by the OS
                                     Called on iOS in applicationWillTerminate()
                                     Called on Android in onDestroy()
                                */
    SDL_APP_LOWMEMORY,          /**< The application is low on memory, free memory if possible.
                                     Called on iOS in applicationDidReceiveMemoryWarning()
                                     Called on Android in onLowMemory()
                                */
    SDL_APP_WILLENTERBACKGROUND, /**< The application is about to enter the background
                                     Called on iOS in applicationWillResignActive()
                                     Called on Android in onPause()
                                */
    SDL_APP_DIDENTERBACKGROUND, /**< The application did enter the background and may not get CPU for some time
                                     Called on iOS in applicationDidEnterBackground()
                                     Called on Android in onPause()
                                */
    SDL_APP_WILLENTERFOREGROUND, /**< The application is about to enter the foreground
                                     Called on iOS in applicationWillEnterForeground()
                                     Called on Android in onResume()
                                */
    SDL_APP_DIDENTERFOREGROUND, /**< The application is now interactive
                                     Called on iOS in applicationDidBecomeActive()
                                     Called on Android in onResume()
                                */

    SDL_LOCALECHANGED,  /**< The user's locale preferences have changed. */

    /* Display events */
    SDL_DISPLAYEVENT   = 0x150,  /**< Display state change */

    /* Window events */
    SDL_WINDOWEVENT    = 0x200, /**< Window state change */
    SDL_SYSWMEVENT,             /**< System specific event */

    /* Keyboard events */
    SDL_KEYDOWN        = 0x300, /**< Key pressed */
    SDL_KEYUP,                  /**< Key released */
    SDL_TEXTEDITING,            /**< Keyboard text editing (composition) */
    SDL_TEXTINPUT,              /**< Keyboard text input */
    SDL_KEYMAPCHANGED,          /**< Keymap changed due to a system event such as an
                                     input language or keyboard layout change.
                                */
    SDL_TEXTEDITING_EXT,       /**< Extended keyboard text editing (composition) */

    /* Mouse events */
    SDL_MOUSEMOTION    = 0x400, /**< Mouse moved */
    SDL_MOUSEBUTTONDOWN,        /**< Mouse button pressed */
    SDL_MOUSEBUTTONUP,          /**< Mouse button released */
    SDL_MOUSEWHEEL,             /**< Mouse wheel motion */

    /* Joystick events */
    SDL_JOYAXISMOTION  = 0x600, /**< Joystick axis motion */
    SDL_JOYBALLMOTION,          /**< Joystick trackball motion */
    SDL_JOYHATMOTION,           /**< Joystick hat position change */
    SDL_JOYBUTTONDOWN,          /**< Joystick button pressed */
    SDL_JOYBUTTONUP,            /**< Joystick button released */
    SDL_JOYDEVICEADDED,         /**< A new joystick has been inserted into the system */
    SDL_JOYDEVICEREMOVED,       /**< An opened joystick has been removed */
    SDL_JOYBATTERYUPDATED,      /**< Joystick battery level change */

    /* Game controller events */
    SDL_CONTROLLERAXISMOTION  = 0x650, /**< Game controller axis motion */
    SDL_CONTROLLERBUTTONDOWN,          /**< Game controller button pressed */
    SDL_CONTROLLERBUTTONUP,            /**< Game controller button released */
    SDL_CONTROLLERDEVICEADDED,         /**< A new Game controller has been inserted into the system */
    SDL_CONTROLLERDEVICEREMOVED,       /**< An opened Game controller has been removed */
    SDL_CONTROLLERDEVICEREMAPPED,      /**< The controller mapping was updated */
    SDL_CONTROLLERTOUCHPADDOWN,        /**< Game controller touchpad was touched */
    SDL_CONTROLLERTOUCHPADMOTION,      /**< Game controller touchpad finger was moved */
    SDL_CONTROLLERTOUCHPADUP,          /**< Game controller touchpad finger was lifted */
    SDL_CONTROLLERSENSORUPDATE,        /**< Game controller sensor was updated */
    SDL_CONTROLLERUPDATECOMPLETE_RESERVED_FOR_SDL3,
    SDL_CONTROLLERSTEAMHANDLEUPDATED,  /**< Game controller Steam handle has changed */

    /* Touch events */
    SDL_FINGERDOWN      = 0x700,
    SDL_FINGERUP,
    SDL_FINGERMOTION,

    /* Gesture events */
    SDL_DOLLARGESTURE   = 0x800,
    SDL_DOLLARRECORD,
    SDL_MULTIGESTURE,

    /* Clipboard events */
    SDL_CLIPBOARDUPDATE = 0x900, /**< The clipboard or primary selection changed */

    /* Drag and drop events */
    SDL_DROPFILE        = 0x1000, /**< The system requests a file open */
    SDL_DROPTEXT,                 /**< text/plain drag-and-drop event */
    SDL_DROPBEGIN,                /**< A new set of drops is beginning (NULL filename) */
    SDL_DROPCOMPLETE,             /**< Current set of drops is now complete (NULL filename) */

    /* Audio hotplug events */
    SDL_AUDIODEVICEADDED = 0x1100, /**< A new audio device is available */
    SDL_AUDIODEVICEREMOVED,        /**< An audio device has been removed. */

    /* Sensor events */
    SDL_SENSORUPDATE = 0x1200,     /**< A sensor was updated */

    /* Render events */
    SDL_RENDER_TARGETS_RESET = 0x2000, /**< The render targets have been reset and their contents need to be updated */
    SDL_RENDER_DEVICE_RESET, /**< The device has been reset and all textures need to be recreated */

    /* Internal events */
    SDL_POLLSENTINEL = 0x7F00, /**< Signals the end of an event poll cycle */

    /** Events ::SDL_USEREVENT through ::SDL_LASTEVENT are for your use,
     *  and should be allocated with SDL_RegisterEvents()
     */
    SDL_USEREVENT    = 0x8000,

    /**
     *  This last event is only for bounding internal arrays
     */
    SDL_LASTEVENT    = 0xFFFF
} 

enum                                                                                                            
{                                                                                                                       
    SDL_RENDERER_SOFTWARE = 0x00000001,         /**< The renderer is a software fallback */                             
    SDL_RENDERER_ACCELERATED = 0x00000002,      /**< The renderer uses hardware                                         
                                                     acceleration */                                                    
    SDL_RENDERER_PRESENTVSYNC = 0x00000004,     /**< Present is synchronized                                            
                                                     with the refresh rate */                                           
    SDL_RENDERER_TARGETTEXTURE = 0x00000008     /**< The renderer supports                                              
                                                     rendering to texture */                                            
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
    int SDL_Init(uint);
	void SDL_Quit();


    void SDL_Delay(uint);
    SDL_Window* SDL_CreateWindow(const char *title, int x, int y, int w, int h, SDL_WindowFlags flags);
    void SDL_DestroyWindow(SDL_Window * window);

	int SDL_PollEvent(SDL_Event * event);

	SDL_Renderer * SDL_CreateRenderer(SDL_Window * window,  int index, uint flags);
	void SDL_DestroyRenderer(SDL_Renderer * renderer);
    int SDL_RenderClear(SDL_Renderer * renderer);
    int SDL_SetRenderDrawColor(SDL_Renderer * renderer, ubyte r, ubyte g, ubyte b, ubyte a);
    int SDL_RenderDrawLine(SDL_Renderer * renderer, int x1, int y1, int x2, int y2);
    void SDL_RenderPresent(SDL_Renderer * renderer);
	int SDL_RenderDrawRect(SDL_Renderer * renderer, const SDL_Rect * rect);
	int SDL_RenderCopy(SDL_Renderer * renderer, SDL_Texture * texture, const SDL_Rect * srcrect, const SDL_Rect * dstrect);


	SDL_Texture * SDL_CreateTextureFromSurface(SDL_Renderer * renderer, SDL_Surface * surface);
	void SDL_DestroyTexture(SDL_Texture * texture);

	void SDL_FreeSurface(SDL_Surface * surface);
	int SDL_SetColorKey(SDL_Surface * surface, int flag, uint key);
	uint SDL_MapRGB(const SDL_PixelFormat * format, ubyte r, ubyte g, ubyte b);
	int SDL_SetTextureBlendMode(SDL_Texture * texture, SDL_BlendMode blendMode);


	SDL_Surface* SDL_LoadBMP_RW(SDL_RWops * src,  int freesrc);
	auto SDL_LoadBMP(const char* file) { return SDL_LoadBMP_RW(SDL_RWFromFile(file, "rb"), 1); }
	SDL_RWops* SDL_RWFromFile(const char *file, const char *mode);
}
