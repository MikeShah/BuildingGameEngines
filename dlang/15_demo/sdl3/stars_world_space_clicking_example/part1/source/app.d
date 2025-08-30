/// Run with: 'dub'
import std.stdio;
import core.stdc.stdlib;
import gameapplication;

// Entry point to program
void main(string[] args)
{
	GameApplication app = GameApplication("D SDL Application");
	app.RunLoop();
}
