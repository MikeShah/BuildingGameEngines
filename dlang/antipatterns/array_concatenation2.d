// @file: array_concatenation.d
//
// In the previous section we learned about 'array concatenation' and a danger with sharing an array that could get realloc'd.
// Again, it is a common behavior you'd find in other programming langauges (e.g. a std::vector in C++, etc.).
// In this next example, I want to show you a performance problem that is also common in many langauges regarding dynamic arrays..

void main(){
    // Note: 'std.datetime' will be used as a stopwatch.
    import std.stdio, std.datetime, std.datetime.stopwatch;

    auto timer1 = StopWatch(AutoStart.no);
    auto timer2 = StopWatch(AutoStart.no);
    auto timer3 = StopWatch(AutoStart.no);
    auto timer4 = StopWatch(AutoStart.no);

    // First we are going to create a few arrays to use as examples.
    // Our goal is going to be to 'append' data to each array.
    // I will add '1' element to them initially
    auto arr1 = [0];
    auto arr2 = [0];
    auto arr3 = [0];
    auto arr4 = [0];

    // Now I want to show the 'performance' of three different strategies 
    // for otherwise appending to an array.

    // (1) Naive approach
    // This approach will simply 'append'.
    // This is probably where to start, and probably a valid solution if
    // you have no idea how big the array will expand.
    timer1.start();
    foreach(elem ; 0..1_000_000){
      arr1 ~= elem;
    } 
    timer1.stop();
    
    // (2) Known quantity
    // If we have some information about the size, or perhaps perfect
    // information we can simply resize our dynamic array to the needed size.
    // Note: If we never needed to expand, we could simply use a dynamic array.
    //       Consider however if we can fit all of the data on the stack 
    //       however in a static array. Otherwise, if you have a very
    //       large 'fixed-size' array, then store it in 'static' memory.
    // Note: For this experiment the result is just slightly different
    //       than the other values of the array since I am putting a value
    //       at index 0. The results however are minimally effected from the
    //       point that I focusing on in this example.
    timer2.start();
    arr2.length = 1_000_000;
    foreach(elem ; 0..1_000_000){
      arr2[elem]= elem;
    } 
    timer2.stop();

    // (3) Unknown quantity, more efficient expansion
    // For this example we could create an 'appender' object that otherwise
    // allows us to use an 'output range'. Appender otherwise helps 'manage'
    // the capacity internally, and can more efficiently expand
    // our data type. 
    import std.array; // std.array.appender
    timer3.start();
    auto my_appender = appender(&arr3);
    foreach(elem ; 0..1_000_000){
      my_appender.put(elem);
      // or equiavalently
      // my_appender ~= elem;
    } 
    timer3.stop();

    // (4) Known quantity, more efficient expansion
    // The 'Appender will also allow us to reserve memory ahead of time
    // as well. We can then assign that memory to the allocated memory from my_appender.
    timer4.start();
    auto my_appender2 = appender!(int[]);
    my_appender2.reserve(1_000_000);
    foreach(elem ; 1..1_000_000){
      my_appender2.put(elem);
      // or equiavalently
      // my_appender2 ~= elem;
    } 
    // The D-runtime as I understand will keep this memory alive when we do the assignment of 'arr4' to our my_appender2.data;
    arr4 = my_appender2.data;
    timer4.stop();

    writeln("Experiment 1 (ns):", timer1.peek.total!"nsecs");
    writeln("Experiment 2 (ns):", timer2.peek.total!"nsecs");
    writeln("Experiment 3 (ns):", timer3.peek.total!"nsecs");
    writeln("Experiment 4 (ns):", timer4.peek.total!"nsecs");

    // There exists more discussion on Appender here otherwise:
    // - https://forum.dlang.org/post/bnsoqxdbcowyxhxzbqcp@forum.dlang.org
    // - https://stackoverflow.com/questions/25537607/d-adding-elements-to-array-without-copying
    // Other langauges have things like 'StringBuilder' which may be similar.
    // If you need thread-safety, look at D's documentation or directly in
    // the Phobos source code for any notes.

}
