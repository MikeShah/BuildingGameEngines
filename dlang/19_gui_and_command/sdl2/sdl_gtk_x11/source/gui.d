import std.stdio;

import gtk.MainWindow;
import gtk.Main;
import gtk.Widget;
import gtk.Button;
import gdk.Event;
import gtk.Container;
import gtk.DrawingArea;
import gtk.Box;
import gtk.Layout; // put
import gtk.Menu;
import gtk.MenuBar;
import gtk.MenuItem;

// GDK functions for grabbing window
import gdk.Window;
import gdk.X11;

import glib.Idle;

// Import D standard libraries
import std.stdio;
import std.string;

// Load the SDL2 library
import bindbc.sdl;


// global variable for window
Window  gdkWindowForSDL;
uint    gdkWindowXID;

interface Command{
	int Execute();
	int Undo();
}

// NOTE: Globals for now, could refactor elsewhere
static SDL_Surface* imgSurface= null;
static Command[] CommandQueue;

class SurfaceOperation : Command{
	SDL_Surface* mSurface;
	int mXPosition;
	int mYPosition;
	
	this(SDL_Surface* surface, int xPos, int yPos){
		mSurface = surface;
		mXPosition = xPos;
		mYPosition = yPos;
	}

	~this(){

	}

	/// Function for updating the pixels in a surface to a 'blue-ish' color.
	int Execute(){
		// When we modify pixels, we need to lock the surface first
		SDL_LockSurface(mSurface);
		// Make sure to unlock the mSurface when we are done.
		scope(exit) SDL_UnlockSurface(mSurface);

		// Retrieve the pixel arraay that we want to modify
		ubyte* pixelArray = cast(ubyte*)mSurface.pixels;
		// Change the 'blue' component of the pixels
		pixelArray[mYPosition*mSurface.pitch + mXPosition*mSurface.format.BytesPerPixel+0] = 255;
			// Change the 'green' component of the pixels
		pixelArray[mYPosition*mSurface.pitch + mXPosition*mSurface.format.BytesPerPixel+1] = 128;
			// Change the 'red' component of the pixels
		pixelArray[mYPosition*mSurface.pitch + mXPosition*mSurface.format.BytesPerPixel+2] = 32;

		return 0;
	}

	int Undo(){
		// When we modify pixels, we need to lock the surface first
		SDL_LockSurface(mSurface);
		// Make sure to unlock the mSurface when we are done.
		scope(exit) SDL_UnlockSurface(mSurface);

		// Retrieve the pixel arraay that we want to modify
		ubyte* pixelArray = cast(ubyte*)mSurface.pixels;
		// Change the 'blue' component of the pixels
		pixelArray[mYPosition*mSurface.pitch + mXPosition*mSurface.format.BytesPerPixel+0] = 0;
			// Change the 'green' component of the pixels
		pixelArray[mYPosition*mSurface.pitch + mXPosition*mSurface.format.BytesPerPixel+1] = 0;
			// Change the 'red' component of the pixels
		pixelArray[mYPosition*mSurface.pitch + mXPosition*mSurface.format.BytesPerPixel+2] = 0;
		return 0;
	}
}


// Entry point to program
void RunSDL()
{
    // Create an SDL window handle
    static SDL_Window* window=null;
    // Flag for determing if we are running the main application loop
    static bool runApplication = true;
    // Flag for determining if we are 'drawing' (i.e. mouse has been pressed
    //                                                but not yet released)
    static bool drawing = false;

    if(window==null){
        writeln("Creating initial window");
        window = SDL_CreateWindowFrom(cast(const(void)*)gdkWindowXID);
        // Do some error checking to see if we retrieve a window
        if(window==null){
            writeln("SDL_GetError()",SDL_GetError());
        }else{
            writeln("Completed creating initial window");
        }
        // Load the bitmap surface
        imgSurface = SDL_CreateRGBSurface(0,640,480,32,0,0,0,0);
    }

    if(window!=null){
		// Blit the surace (i.e. update the window with another surfaces pixels
		//                       by copying those pixels onto the window).
		SDL_BlitSurface(imgSurface,null,SDL_GetWindowSurface(window),null);
		// Update the window surface
		SDL_UpdateWindowSurface(window);
		// Delay for 16 milliseconds
		// Otherwise the program refreshes too quickly
		//SDL_Delay(16);
    }

    // Free the image
    scope(exit) {
//            SDL_FreeSurface(imgSurface);
    }
    // Destroy our window
//    SDL_DestroyWindow(window);
}


void QuitApp(){
	writeln("Terminating application");

	Main.quit();
}


bool onMousePress(Event event, Widget widget)
{
	bool value = false;
	
	if(event.type == EventType.BUTTON_PRESS)
	{
		GdkEventButton* mouseEvent = event.button;
		value = true;

		// Create a new command
		auto command = new SurfaceOperation(imgSurface,cast(int)mouseEvent.x,cast(int)mouseEvent.y);
		// Append to the end of our queue
		CommandQueue ~= command;
		// Execute the last command
		CommandQueue[$-1].Execute();

		writeln("Commands in Queue: ", CommandQueue.length);
	}

	return(value);
}


void main(string[] args)
{
	// Initialize GTK
	Main.init(args);
	// Setup our window
	MainWindow myWindow = new MainWindow("Tutorial 02");
    myWindow.setTitle("SDL with gtk+3 example");
	// Position our window
	myWindow.setDefaultSize(640,480);
	int w,h;
	myWindow.getSize(w,h);
	writeln("width   : ",w);
	writeln("height  : ",h);
	myWindow.move(100,120);
	
	// Delegate to call when we destroy our application
	myWindow.addOnDestroy(delegate void(Widget w) { QuitApp(); });

    // Create a new Box
    const int globalPadding=2;
    auto myBox = new Box(Orientation.VERTICAL,globalPadding);

    // Create a menu bar and menu items
    auto menuBar = new MenuBar;
    auto menuItem1 = new MenuItem("File");
    menuBar.append(menuItem1);

    // Create a menu for our menu item
    auto menu1 = new Menu;
    auto menuNew  = new MenuItem("New");
    auto menuExit = new MenuItem("Exit");

    // Add some functions to our menu 
    // We use a delagate, and observe this time that we are
    // using 'MenuItem m' as our parameter because that is the type.
    menuNew.addOnActivate(delegate void (MenuItem m){writeln("pressed new");}); 
    menuExit.addOnActivate(delegate void (MenuItem m){writeln("pressed exit");}); 

    // Append menu items to our menu
    menu1.append(menuNew);
    menu1.append(menuExit);
    // Attach this menu item as a submenu
    menuItem1.setSubmenu(menu1);
         
    // Add menu and do not expand or fill or pad 
    myBox.packStart(menuBar,false,false,0);

	// We'll now create a 'button' to add to our aplication.
	Button myButton1 = new Button("Button1 Text");
	Button myButton2 = new Button("Button2 Text");
//	Button myButton3 = new Button("Button3 Text");

    Layout myLayout = new Layout(null,null);
//    myLayout.put(myButton3,0,167);

    const int localPadding= 2;
    //              button    expand fill padding
    myBox.packStart(myButton1,true,true,localPadding);
    myBox.packStart(myButton2,true,true,localPadding);
    myBox.packStart(myLayout,true,true,localPadding);

	// Action for when we click a button
	myButton1.addOnClicked(delegate void(Button b) { writeln("myButton1Clicked");  });
	myButton2.addOnClicked(delegate void(Button b) { writeln("myButton1Clicked");  });
	// Action for when mouse is released
	myButton1.addOnReleased(delegate void(Button b){ writeln("myButton2Released"); });
	myButton2.addOnReleased(delegate void(Button b){ writeln("myButton2Released"); });
 
    // Create a new drawing area
    auto gtkDrawingArea = new DrawingArea;
    gtkDrawingArea.setSizeRequest(640,480);
    myBox.packStart(gtkDrawingArea,true,true,localPadding);
	gtkDrawingArea.addOnButtonPress(delegate bool (Event e,Widget widget){
		return onMousePress(e,widget);
	});

    // Add to our window the box
    // as a child widget
    myWindow.add(myBox);

    // Create a container to store the drawing area
    auto myContainer = new GtkContainer;
    //myContainer.add(gtkDrawingArea);
    //myWindow.add(myContainer);
    
	// Show our window
	myWindow.showAll();

    //cast(gulong)gdk_quartz_window_get_nsview(gtk_widget_get_window((gtkDrawingArea.getWindow())));

    // Useful information for SDL within a GTK window
    // https://stackoverflow.com/questions/47284284/how-to-render-sdl2-texture-into-gtk3-window
    //auto gdk_window = gtk_widget_get_window(GTK_WIDGET(myWindow));
    //auto window_id = cast(void*)cast(int*)GDK_WINDOW_XID(gtkDrawingArea);
//    gtkDrawingArea.realize(); // May not be necessary, but forces component to be built first
    gdkWindowForSDL = gtkDrawingArea.getWindow(); 
    gdkWindowXID = gdkWindowForSDL.getXid();

    writeln("gdkWindowForSDL",typeid(gdkWindowForSDL));

    // Creating a new idle event will fire whenever there is not anything
    // else to do
    auto idle = new Idle(delegate bool(){ RunSDL(); return true;});

	// Run our main loop
	Main.run();
}
