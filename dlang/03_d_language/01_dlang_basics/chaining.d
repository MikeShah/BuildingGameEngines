/// @file dlang_basics/chaining.d
import std.stdio;
import std.string;

void main(){

	string sentence = " mike was here ";

    /// Ugly way to do it without chaining and ufcs
    /// Much harder to read (inside to outside, too many parenthesis...)
    writeln(strip(replace(toUpper(sentence),"MIKE","joe")));


	/// Read this left-to right
	writeln(sentence.strip.toUpper.replace("MIKE","joe").strip);

	/// Apply operations top to bottom
	writeln(sentence.strip
					.toUpper
					.replace("MIKE","joe")
					.strip
			);
}

