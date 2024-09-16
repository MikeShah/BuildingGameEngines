// @file package3/main.d

void main(){
    // Selective import with a 
    // local scope of the 'main' function
    import animal.cat : Cat;
    import animal.dog : Dog;
    import std.stdio : writeln;
    import std.traits;

    // Shorten or change the full name for Cat
    import troublemaker = animal.cat;
    alias Garfield = troublemaker.Cat;

    Dog d = new Dog;
    Garfield c = new Cat;

    writeln("Cat            : ",fullyQualifiedName!(Cat));
    writeln("Garfield alias : ",fullyQualifiedName!(Garfield));
}



