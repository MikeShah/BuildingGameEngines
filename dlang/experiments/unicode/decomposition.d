/+ @file: decomposition.d
	The purpose of this file is to demonstrate how to transform
	unicode into ascii text. This is probably not ideal, but it may
	be necessarily if your database for instance only stores text in
	ascii form.

	You should otherwise consider looking at 'dchar' types to otherwise
	make sure you can support multiple languages. See topics on 
	'localization' in game and application development otherwise.
+/
import std.stdio;
import std.uni;
import std.ascii;

void main(){
	// The Roman or Latin Alphabet has symbols from a-z,A-Z that otherwise
	// we often use in the English language.
	// However, the world contains many wonderful langauges with different 
	// symbols and graphics to represent speech and written communication.
	// Thus, as computer scientists, we need to work with many different types
	// of characters.
	// According to https://en.wikipedia.org/wiki/List_of_Unicode_characters
	// there are around 292.531 assigned characters to cover ~168 historical scripts.

	// For this purpose, d provides 'string' which we are familiar with,
	// which is an immutable array of 8-bit characters.
	// dstring (and dchar) otherwise provides us with a different type.
	writeln("string.stringof: ", typeid(string).stringof);
	writeln("char.sizeof : ", char.sizeof);
	writeln("dchar.sizeof: ", dchar.sizeof);

	// d string can represent more 'stuff'. So what can we do with
	// ascii only representatation? Well, we can try to do some replacement
	
	dstring wordWithMoreThan26RomanCharacters = "résumé";
	string asciiString = UnicodeToASCIIstringApproximation(wordWithMoreThan26RomanCharacters);

	// Foundation
	writeln("wordWithMoreThan26RomanCharacters: ",wordWithMoreThan26RomanCharacters);
	writeln("asciiString: ",asciiString);

}


string UnicodeToASCIIstringApproximation(dstring unicode_input){
	string result;

	// An imperfect approximation of characters.
	char[dchar] unicodeTable =	['é':'e',
	 'è':'e',
	 'ù':'u',
	 'ç':'c',
	 'â':'a',
	 'ê':'e',
	 'î':'i',
	 'ô':'o',
	 'û':'u',
	 'ë':'e',
	 'ï':'i',
	 'ü':'u',
	];

	foreach(dchar_ ; unicode_input){
		if(dchar_.isASCII){
			result ~= dchar_; // Attemps 	
		}else if(dchar_ in unicodeTable){
			result ~= unicodeTable[dchar_];
		}else{
			result ~= '?';
		}
	}
	return result;
}
