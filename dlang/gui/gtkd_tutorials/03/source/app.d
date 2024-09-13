import std.stdio;

import gtk.MainWindow;
import gtk.Main;
import gtk.Widget;
import gtk.Button;
import gdk.Event;


void QuitApp(){
	writeln("Terminating application");

	Main.quit();
}

void main(string[] args)
{
	
	// Initialize GTK
	Main.init(args);
	// Setup our window
	MainWindow myWindow = new MainWindow("Tutorial 03");
	// Now we are going to force our window to a specific size.
   	// NOTE: You can use 'setSizeRequest(width,height)' to 
	//       request a size, but generally I just force the size.	
	myWindow.setDefaultSize(640,480);
	int w,h;
	myWindow.getSize(w,h);
	writeln("width   : ",w);
	writeln("height  : ",h);

	// Let's also move our window to a specific location.
	// so that it is at the same position every time we run.
	// We'll move our window 100 pixels from the top-left,
	// and then 120 pixels down from the top-left origin.
	myWindow.move(100,120);
	
	// Delegate to call when we destroy our application
	myWindow.addOnDestroy(delegate void(Widget w) { QuitApp(); });

	// We'll now create a 'button' to add to our aplication.
	Button myButton = new Button("Button Text");

	// Action for when we click a button
	myButton.addOnClicked(delegate void(Button b) {
						QuitApp();
						});

	// Add our button as a child of our window
	myWindow.add(myButton);

	// Show our window
	myWindow.showAll();

	// Run our main loop
	Main.run();
}
