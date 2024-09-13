import std.stdio;

import gtk.MainWindow;
import gtk.Main;
import gtk.Widget;
// Add new dependencies for supporting buttons and events
import gtk.Button;
// Note: 'gdk' is a drawing library
//        It is part of 'gtk', and gtk is built on top of gdk.
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
	MainWindow myWindow = new MainWindow("Tutorial 02");

	// Delegate to call when we destroy our application
	myWindow.addOnDestroy(delegate void(Widget w) { QuitApp(); });

	// We'll now create a 'button' to add to our aplication.
	Button myButton = new Button("Button Text");
	// When our button is cicked, we'll add an action again using a delegate.
	// This action is a 'signal' that is added.
	// Signals are gtk's way of keeping track of some 'notification' that
	// occurs.
	myButton.addOnClicked(delegate void(Button b) {
						QuitApp();
						});

	// Add our button to our window.
	// Our button in a sense is a 'child' of the window
	// NOTE: You'll observe that our 'myWindow' has shrunk
	//       to its child size. We'll work on sizing later on.
	myWindow.add(myButton);

	// Show our window
	myWindow.showAll();

	// Run our main loop
	Main.run();
}
