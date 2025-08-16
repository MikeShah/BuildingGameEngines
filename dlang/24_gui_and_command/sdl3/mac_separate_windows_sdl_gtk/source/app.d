import std.stdio;
import std.concurrency: spawn;

import gtk.MainWindow;
import gtk.Main;
import gtk.Widget;
import gtk.Button;
import gdk.Event;

import glib.Idle;

import sdl_win;

void QuitApp(){
	writeln("Terminating application");

	Main.quit();
}

void main(string[] args){
	// Initialize GTK
	Main.init(args);

	// Setup our window
	MainWindow myWindow = new MainWindow("Tutorial 02");
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

	// Action for when mouse is released
	myButton.addOnReleased(delegate void(Button b){
							writeln("myButtonReleased");
						});

	// Add our button as a child of our window
	myWindow.add(myButton);

	// Show our window
	myWindow.showAll();

	// Spawn our GUI Window
	immutable string[] args2=args.dup;

    // Create the SDL window and have it render when
    // there are not otherwise events going on in the GUI
    // NOTE: 
    auto idle = new Idle(delegate bool(){ return RunSDL(args2);});
	// Run our main loop
	Main.run();
}
