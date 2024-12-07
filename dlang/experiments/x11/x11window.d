// Based on the tutorial: https://hereket.com/posts/linux_creating_x11_windows/
//
// Build with: rdmd -L-lx11 x11window.d
//
// Run the example and pass to the linker 'lx11' to link in
// Note the first '-L' tells  us to pass some argument to the linker, you then// pass in '-l' to link a library, and specifically 'x11'
// NOTE: The order matters in D, as D has a 'deterministic' order


// x11 documentation: https://www.x.org/releases/X11R7.6/doc/libX11/specs/libX11/libX11.html

// Forward declare Display
struct Display;

// In X11, 'window' is merely a handle, which is known as an 'XID' (just an unsigned long)
alias XID = ulong;
alias Window = XID;

// C Interface
extern(C){
		Display* XOpenDisplay(const char *display_name);
		Window XDefaultRootWindow(Display *display);
		Window XCreateSimpleWindow(Display* display, Window parent, int x, int y, uint width, uint height, uint border_width, ulong border, ulong background);
		int XMapWindow(Display *display, Window w);
		int XFlush(Display* display);
}


/// Entry to program
void main(){
		Display* mainDisplay = XOpenDisplay(null);
		Window rootWindow = XDefaultRootWindow(mainDisplay);

		Window mainWindow = XCreateSimpleWindow(mainDisplay, rootWindow, 0, 0, 800, 600, 0, 0, 0x00aade87);
		XMapWindow(mainDisplay, mainWindow);

		XFlush(mainDisplay);

		for(;;){}
}
