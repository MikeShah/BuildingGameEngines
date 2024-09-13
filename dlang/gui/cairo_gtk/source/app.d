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

// Cairo drawing functions
import cairo.Context;
import gdk.Pixbuf;
import gdkpixbuf.Pixbuf;

import glib.Idle;

// Import D standard libraries
import std.stdio;
import std.string;

// Example function to call to quit application
// from gtk
void QuitApp(){
	writeln("Terminating application");

	Main.quit();
}


class ExampleDrawingArea : DrawingArea{

	Pixbuf pixbuf; // image buffer with pixel information
	GtkAllocation size; // Actual drawing area 
	Context ctx;


	// Store some internal state for mouse presses
	double xPos,yPos;
	bool   drawing;

	this(){
		xPos = 0.0;
		yPos = 0.0;
		this.drawing=false;
		addOnDraw(&onDraw);
		addOnButtonPress(&onMousePressed);
		addOnButtonRelease(&onMouseReleased);
		addOnMotionNotify(&onMouseMoved);
	}

	//
	bool onDraw(Scoped!Context context, Widget w){
		// https://api.gtkd.org/cairo.Context.Context.html
		// Set the current color for operations.

		context.newPath();
		context.moveTo(xPos,yPos);
		context.setSourceRgb(0.5,0.9,0.1); // pen color

		writeln("drawing",xPos,",",yPos);
		context.rectangle(xPos,yPos,10,10); 
		
		context.fill();

		context.paint();

		ctx = context;
				
		return true;
	}

	// Handle mouse presses
	bool onMousePressed(Event event, Widget widget){
    	bool result = true;
    	if(event.type == EventType.BUTTON_PRESS){
			writeln("mouse pressed");
        	// Set drawing to true so we are in a draw state
        	drawing=true;
    	}

    	return result;
	}

	// Handle mouse release events
	bool onMouseReleased(Event event, Widget widget){
    	bool result=false;
		writeln("mouse released");

    	if(event.type == EventType.BUTTON_RELEASE){
        	drawing = false;
    	}

    	return result;
	}
	bool onMouseMoved(Event event, Widget widget){
    	bool result=false;
    
    	if(event.type == EventType.MOTION_NOTIFY && drawing==true){
        	// Retrieve coordinates of where event happened
        	event.getRootCoords(xPos,yPos);
        	writeln("(rootCoords) mouse pressed:",xPos,",",yPos);
        	event.getCoords(xPos,yPos);
        	writeln("(relativeCoords) mouse pressed:",xPos,",",yPos);
		}
		return result;
	}
}


// Entry point into program
void main(string[] args)
{
	// Initialize GTK
	Main.init(args);
	// Setup our window
	MainWindow myWindow = new MainWindow("Tutorial 07?");
    myWindow.setTitle("gtk+3 example");
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
    auto gtkDrawingArea = new ExampleDrawingArea;
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

    gtkDrawingArea.realize(); // May not be necessary, but forces component to be built first
 
    // Handle events on our main window
    // Essentially hook up a bunch of functions to handle input/output
    // events in our program.
//    myWindow.addOnButtonPress(delegate bool(Event e,Widget w){ return onMousePressed(e,w);});
//    myWindow.addOnButtonRelease(delegate bool(Event e,Widget w){ return onMouseReleased(e,w);});
//    myWindow.addOnMotionNotify(delegate bool(Event e,Widget w){ return onMouseMoved(e,w);});

	// Run our main gtk+3 loop
	Main.run();
}
