// 01/source/app.d
import std.stdio;
// Import the dependencies for gtk-d
import gtk.MainWindow;
import gtk.Main;
import gtk.Widget;

void QuitApp(){
	writeln("Terminating application");
	Main.quit();
}

void main(string[] args)
{
	// GTK itself is a 'C' based library.
	// This means that we need to call 'init' (the equivalent of a constructor)
	// in order to setup our windowing system.
	// We can forward our arguments in D to the 'Main' in our GUI application.
	Main.init(args);
	MainWindow firstWindow = new MainWindow("Tutorial 01");
	// Again, because GTK is a 'C' based library, there is no destructor.
	// We 'build up' the destructor, by adding a series of functions
	// that we want to call when we destroy the window.
	// Think of it as 'add this function to be called when we'-- 'OnDestroy'
	firstWindow.addOnDestroy(delegate void(Widget w) { QuitApp(); });
	// NOTE: In the above we are using a 'delegate'. 
	//       'delegates' are a bit more powerful then function pointers, in then
	// 		 sense that they can access data in their local scope.
	// Here's an explanation: https://forum.dlang.org/post/mailman.1908.1334790932.4860.digitalmars-d-learn@puremagic.com
	writeln("Hello GtkD");
	// Show our window and any of its components.
	// See: https://docs.gtk.org/gtk3/#gtk-widget-show-all
	firstWindow.showAll();
	// Give control to GTK library to run its main loop.
	// Effectively, the 'MainWindow' has its own loop that is executing
	// and managed until we explicitly end the program.
	Main.run();
}
