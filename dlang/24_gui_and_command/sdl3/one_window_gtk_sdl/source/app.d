/*
    The following is a sample with using gtk+3 with SDL2.
    Note that we want to handle all events from one library,
    in this case gtk.

*/
// Imports from dependencies
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

// For Mac drawing
import cairo.Context;

// Import D standard libraries
import std.stdio;
import std.string;

// Load the SDL2 library
import bindbc.sdl;
import sdl_abstraction;


// Some global variables
// TODO: Remove or contain global state in a struct.
Window          gdkWindowForSDL;
uint            gdkWindowXID;
Command[]       CommandQueue;
SDL_Surface*    imgSurface= null;
bool            drawing = false;
double          gxPos,gyPos;
Context         gCairoContext;

// Interface for a command
interface Command{
	int Execute();
	int Undo();
}

// Example class for implementing a command
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
		pixelArray[mYPosition*mSurface.pitch + mXPosition*4+0] = 255;
			// Change the 'green' component of the pixels
		pixelArray[mYPosition*mSurface.pitch + mXPosition*4+1] = 128;
			// Change the 'red' component of the pixels
		pixelArray[mYPosition*mSurface.pitch + mXPosition*4+2] = 32;

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
		pixelArray[mYPosition*mSurface.pitch + mXPosition*4+0] = 0;
			// Change the 'green' component of the pixels
		pixelArray[mYPosition*mSurface.pitch + mXPosition*4+1] = 0;
			// Change the 'red' component of the pixels
		pixelArray[mYPosition*mSurface.pitch + mXPosition*4+2] = 0;
		return 0;
	}
}


// Handle mouse presses
bool onMousePressed(Event event, Widget widget){
    writeln("onMousePressed",gxPos,",",gyPos);
    bool result = false;
    if(event.type == EventType.BUTTON_PRESS){
        // Set drawing to true so we are in a draw state
        drawing=true;
    }

    if(event.type == EventType.MOTION_NOTIFY && drawing==true){
        // Retrieve coordinates of where event happened
        event.getRootCoords(gxPos,gyPos);
        writeln("(rootCoords) mouse pressed:",gxPos,gyPos);
        event.getCoords(gxPos,gyPos);
        writeln("(relativeCoords) mouse pressed:",gxPos,gyPos);
    }

    return result;
}

// Handle mouse motion after moving brush
bool onMouseMoved(Event event, Widget widget){
    writeln("onMouseMoved");
    bool result=false;
    
    if(event.type == EventType.MOTION_NOTIFY && drawing==true){
        // Retrieve coordinates of where event happened
        event.getCoords(gxPos,gyPos);
        writeln("onMouseMoved",gxPos,",",gyPos);

        version(linux){
            // Loop through and update specific pixels
            // NOTE: No bounds checking performed --
            //       think about how you might fix this :)
            int brushSize=4;
            for(int w=-brushSize; w < brushSize; w++){
                for(int h=-brushSize; h < brushSize; h++){
                    // Create a new command
                    auto command = new SurfaceOperation(imgSurface,cast(uint)(gxPos+w),cast(uint)(gyPos+h));
                    // Append to the end of our queue
                    CommandQueue ~= command;
                    // Execute the last command
                    CommandQueue[$-1].Execute();
                }
            }
        }
        result = true;

    }

    return result;
}


// Handle mouse release events
bool onMouseReleased(Event event, Widget widget){
    writeln("onMouseReleased",gxPos,",",gyPos);
    bool result=false;

    if(event.type == EventType.BUTTON_RELEASE){
        drawing = false;
    }

    return result;
}

// SDL Portion of the program 
static bool RunSDL()
{
    static SDL_Window* window=null;
    // Flag for determing if we are running the main application loop
    static bool runApplication = true;
    // Flag for determining if we are 'drawing' (i.e. mouse has been pressed
    //                                                but not yet released)

    if(window==null){
      // SDL2 way of doing this
//        window = SDL_CreateWindowFrom(cast(const(void)*)gdkWindowXID);
        // In SDL3, we need to use some of the properties to otherwise help faciliate
        // our window creation.
        SDL_PropertiesID props = SDL_CreateProperties();
        SDL_SetNumberProperty(props,SDL_PROP_WINDOW_CREATE_X11_WINDOW_NUMBER,gdkWindowXID);
        window = SDL_CreateWindowWithProperties(props);

        // Do some error checking to see if we retrieve a window
        if(window==null){
            writeln("window-SDL_GetError()",SDL_GetError());
        }
        // Load the bitmap surface
        imgSurface = SDL_CreateSurface(640,480,SDL_PIXELFORMAT_RGBA8888);
        if(imgSurface==null){
            writeln("imgSurface-SDL_GetError()",SDL_GetError());
        }
    }

    if(window!=null){
            // Blit the surace (i.e. update the window with another surfaces pixels
            //                       by copying those pixels onto the window).
            SDL_BlitSurface(imgSurface,null,SDL_GetWindowSurface(window),null);
            // Update the window surface
            SDL_UpdateWindowSurface(window);
            // Delay for 16 milliseconds
            // Otherwise the program refreshes too quickly
        //}
    }

    // Free the image
    scope(exit) {
//            SDL_FreeSurface(imgSurface);
    }
    // Destroy our window
//    SDL_DestroyWindow(window);
    return true;
}


// Example function to call to quit application
// from gtk
void QuitApp(){
	writeln("Terminating application");

	Main.quit();
}


// Entry point into program
void main(string[] args)
{
	// Initialize GTK
	Main.init(args);
	// Setup our window
	MainWindow myWindow = new MainWindow("Tutorial 06?");
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
    const int localPadding= 2;
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

    // Append menu items to our menu
    menu1.append(menuNew);
    menu1.append(menuExit);
    // Attach this menu item as a submenu
    menuItem1.setSubmenu(menu1);
         
    // Add menu and do not expand or fill or pad 
    myBox.packStart(menuBar,false,false,0);

    // Create a new drawing area
    auto gtkDrawingArea = new DrawingArea;
    gtkDrawingArea.setSizeRequest(640,480);
    myBox.packStart(gtkDrawingArea,true,true,localPadding);

	// We'll now create a 'button' to add to our aplication.
	Button myButton1 = new Button("Button1 Text");
	Button myButton2 = new Button("Button2 Text");
	Button myButton3 = new Button("Button3 Text");

    Layout myLayout = new Layout(null,null);
    myLayout.put(myButton3,0,0);

    //              button    expand fill padding
    myBox.packStart(myButton1,true,true,localPadding);
    myBox.packStart(myButton2,true,true,localPadding);
    myBox.packStart(myLayout,true,true,localPadding);

	// Action for when we click a button
//	myButton1.addOnClicked(delegate void(Button b) {
//							writeln("myButtonClicked");
//						});

	// Action for when mouse is released
//	myButton1.addOnReleased(delegate void(Button b){
//							writeln("myButtonReleased");
//						});
 

    // Add to our window the box
    // as a child widget
    myWindow.add(myBox);

    // Create a container to store the drawing area
    auto myContainer = new GtkContainer;
    //myContainer.add(gtkDrawingArea);
    //myWindow.add(myContainer);
    
	// Show our window
	myWindow.showAll();

    // Useful information for SDL within a GTK window
    // https://stackoverflow.com/questions/47284284/how-to-render-sdl2-texture-into-gtk3-window
    version(linux){
        gtkDrawingArea.realize(); // May not be necessary, but forces component to be built first
        gdkWindowForSDL = gtkDrawingArea.getWindow(); 
        gdkWindowXID = gdkWindowForSDL.getXid();
        // Creating a new idle event will fire whenever there is not anything
        // else to do -- effectively this is where we will draw in SDL
        auto idle = new Idle(delegate bool(){ return RunSDL();});
    } 
    version(OSX){

        gtkDrawingArea.realize(); // May not be necessary, but forces component to be built first
        gdkWindowForSDL = gtkDrawingArea.getWindow(); 
        
        gtkDrawingArea.addOnDraw(delegate bool(Scoped!Context context, Widget w){
            writeln("Drawing with cairo on mac");
            gCairoContext = context;
            writeln("Trying this:",gxPos,",",gyPos);
            gCairoContext.setLineWidth(3);
            gCairoContext.moveTo(gxPos,30);
            gCairoContext.lineTo(100,75);
            gCairoContext.stroke(); 
            return true;
        });
            
    }


    // Handle events on our main window
    // Essentially hook up a bunch of functions to handle input/output
    // events in our program.
    myWindow.addOnButtonPress(delegate bool(Event e,Widget w){ return onMousePressed(e,w);});
    myWindow.addOnButtonRelease(delegate bool(Event e,Widget w){ return onMouseReleased(e,w);});
    myWindow.addOnMotionNotify(delegate bool(Event e,Widget w){ return onMouseMoved(e,w);});

	// Run our main gtk+3 loop
	Main.run();
}
