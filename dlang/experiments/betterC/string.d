// dmd -betterC -unittest -main string.d
// Nice way to build fast:
// ls string.d | entr -c -s 'dmd -g -betterC -unittest -main string.d && ./string '
module dynarray;

extern(C):

import core.stdc.stdio;
import core.stdc.stdlib;


/// Finds the index of a character in a string
int indexOf(string s, char c, size_t startIdx =0){
	int result = -1;
	for(size_t i = startIdx; i < s.length; i++){
		if(s[i]==c){
			result = cast(int)i;
			break;
		}
	}
	return result;
}

unittest{
	printf("indexOf Test\n");
	assert(indexOf("hello",'h') ==0, "indexOf 0");
	assert(indexOf("hello",'o') ==4, "indexOf 4");
	assert(indexOf("hello",'q') ==-1, "indexOf -1");
	assert(indexOf("hello",'q',2) ==-1, "indexOf -1");
	assert(indexOf("hello",'l',2) ==2, "indexOf 2");
	assert(indexOf("hello",'l',3) ==3, "indexOf 3");
}


extern(C) void main()
{
    static foreach(u; __traits(getUnitTests, __traits(parent, main)))
        u();
}
