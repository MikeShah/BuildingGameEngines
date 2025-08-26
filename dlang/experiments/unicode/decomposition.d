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


/// The purpose of a function like this is to trade computation and accuracy
/// (i.e. spend time converting characters, and losing accuracy) to otherwise
/// save in database/memory storage by only storing the Roman characters
/// that fit in a simple 8-bit value(char).
///
/// You should consider if this is necessary for your purposes, or if it is
/// otherwise better to commit to using 'dstring' everywhere for precision.
/// dchar and dstring however come with the trade-off that things like computing
/// the length of a string are less trivial.
string UnicodeToASCIIstringApproximation(dstring unicode_input){
	string result;

	// An imperfect approximation of characters.
	// Note: I've made this 'static' because I do not need to reallocate
	//       the table every time the function is called.
	static char[dchar] unicodeTable =	['é':'e',
	'Á':'A',		'à':'a',		'À':'A',		'â':'a',	
	'Â':'A',		'ä':'a',		'Ä':'A',		'ã':'a',	
	'Ã':'A',		'å':'a',		'Å':'A',		'æ':'a',	
	'Æ':'a',	
	'ç':'c',		'Ç':'C',		'é':'e',	
	'É':'E',		'è':'e',		'È':'E',		'ê':'e',	
	'Ê':'E',		'ë':'e',		'Ë':'E',	
	'í':'i',		'Í':'I',		'ì':'i',		'Ì':'I',	
	'î':'i',		'Î':'I',		'ï':'i',		'Ï':'I',	
	'ñ':'n',		'Ñ':'N',	
	'ó':'o',		'Ó':'O',		'ò':'o',		'Ò':'O',	
	'ô':'o',		'Ô':'O',		'ö':'o',		'Ö':'O',	
	'õ':'o',		'Õ':'O',		'ø':'o',		'Ø':'O',	
	'œ':'o',		'Œ':'O',		'ß':'B',		'ú':'u',	
	'Ú':'U',		'ù':'u',		'Ù':'U',	
	'û':'u',		'Û':'U',		'ü':'u',		'Ü':'U',	
	];

	// Simply iterate through the characters and make an
	// 'approximate' substitution
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
