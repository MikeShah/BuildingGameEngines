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
	MainWindow myWindow = new MainWindow("Tutorial 04");
	// Position our window
	myWindow.setDefaultSize(640,480);
	int w,h;
	myWindow.getSize(w,h);
	writeln("width   : ",w);
	writeln("height  : ",h);
	myWindow.move(100,120);
	
	// Delegate to call when we destroy our application
	myWindow.addOnDestroy(delegate void(Widget w) { QuitApp(); });

	// We'll now create a 'button' to add to our aplication.
	Button myButton = new Button("Button Text");

	// Action for when we click a button
	myButton.addOnClicked(delegate void(Button b) {
							writeln("myButtonClicked");
						});

	// Let's add another type of action here.
	// This time we'll add a delegate for when our
	// button is released.
	myButton.addOnReleased(delegate void(Button b){
							writeln("myButtonReleased");
						});


	// Add our button as a child of our window
	myWindow.add(myButton);

	// Show our window
	myWindow.showAll();

	// Run our main loop
	Main.run();
}
