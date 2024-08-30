// @file controlflow.d
import std.stdio;

void main(){

    // Same as all C based languages
    if(1==1 || 2==2){

    }else if (1==2 && 4==5){

    }
    else{

    }

    int value=4;
    switch(value){
        // Can have a 'range' for the cases
        case 0: .. case 5:
                writeln("value between 0 and 5 inclusive");
                break;
        case 6:
                writeln("value is 6");
                break;
        default: // if no matches
                writeln("value is less than 0 or >6");
                break;
    }

}



