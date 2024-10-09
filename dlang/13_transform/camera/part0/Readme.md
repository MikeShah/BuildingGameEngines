# Math Library 

> "A fundamental library for game programming"

# Resources to help

Provided below are a list of curated resources to help you complete the task(s) below. Consult them (read them, or do ctrl+f for keywords) if you get stuck.

| D Programming Related Links                         | Description                       |
| --------------------------------------------------  | --------------------------------- |
| [My D Youtube Series](https://www.youtube.com/playlist?list=PLvv0ScY6vfd9Fso-3cB4CGnSlW0E4btJV) | My video series playlist for learning D Lang. |
| [DLang Phobos Standard Library Index](https://dlang.org/phobos/index.html)  | The Phobos Runtime Library (i.e. standard library of code.)
| [D Language Tour](https://tour.dlang.org/)           | Nice introduction to the D Language with samples you can run in the browser. |
| [Programming in D](https://ddili.org/ders/d.en/)     | Freely available D language programming book |
| [My SDL Playlist](https://www.youtube.com/playlist?list=PLvv0ScY6vfd-p1gSnbQhY7vMe2rng0IL0)     | My SDL Playlist |

## Description

Previously we have discussed and reviewed some math concepts. Now it's time for you to implement them in code! For your assignment today, you will be filling out the 'TODO' portions of the Vec2 library.

For the purpose of this assignment, I also want to discuss a little bit about how to go about building the data structure.

## Template Constraints

You'll notice at the top of the data structure this template constraint. This helps ensure that we do not otherwise instantiate instances of the Vec2 type that otherwise do not consist of primitives. This is a good practice, and it can help protect against edge cases if your structures are not truly generic.

```d
if(__traits(isIntegral,T) || __traits(isFloating,T)) 
```

## union of anonymous struct

You're going to notice this chunk of code and just figure it's way more complicated than it needs to be. In some ways -- you're right! However, the Vec2 data type can be used in so many contexts, we can improve the API for our end users. Graphics programming languages for instance use this feature below where I can access the individual components of a vector as 'x and y' or perhaps 's and t'. At the end of the day, x and s for instance will hold the same value, but the context helps 'self-document' our code. This is a trick you can use in systems languages (e.g. C, C++, D, etc.) -- it's good to know how our language otherwise works.

```d

		// Internal Data
		// Note: It's convenient to be able to access 
		//       in different ways to provide context to the user
		//       about what problem you're trying to solve.
		// Note: It's important to initialize these values. 
		//       If you have a float type that initializes to NaN,
		//       you will indeed get lots of assertion errors.
		// Note: When you print out a union, or data structure with a union,
		//       D will show you all of the union, but again remember, that
		//       the size of the type is not what you see.
		union{
			struct{
				T x=0,y=0;
			}
			struct{
				T s,t;
			}
			struct{
				T i,j;
			}
			struct{
				T[2] elem;
			}
		}
```

## Member function or free function?

In my implementation below of dot product below I opted to make it a 'free function'. That is, it did not need to be part of my 'struct'. 

How did I make this decision? Well some of this is just experience, and some of this is a preference that I tend to like moving things out to be free functions as they may just be more useful. For isntance if you stare at the function long enough, you'll realize you can easily make this a variadic function that can take any vector of any length. That can sometimes be harder to see if it's just isolated within the struct it belongs.

```
// Return the scalar dot product to determine how                                                                       
// similar two vectors are.                                                                                             
double Dot(T)(T v1, T v2){                                                                                              
    return (v1.x*v2.x) + (v1.y*v2.y);                                                                                   
} 
```

The other part of the story however, is that with D language's Universal Function Call Syntax, you can still write `Dot(v1,v2)` as `v1.Dot(v2)` -- it's effectively the same thing.

## Operator Overloading in D

The D language allows you to perform operator overloading. Typically this is useful when you want to create datatypes and implement things like +,-,+=,*=, etc. Of course, you can also override other operators like '~' (concatentaiton) or '[]' (for indexing), or even [1 ..3] (opSlice) if you have a container. I've found it is often very conveneint for a datatype like a Vector2 to otherwise overload the operators.

- An excellent guide for operator overloading is provided here: https://dlang.org/spec/operatoroverloading.html
- I can also recommend Ali's Programming in D chapter here: https://ddili.org/ders/d.en/operator_overloading.html

Provided below is a minimal sample of some D code (I suggest you just copy and run this example and read the comments as you go -- in practice it's only a few lines of code)

```d
// overload.d
// rdmd overload.d
import std.stdio;

struct Vec2f{
    float x,y;

    this(float _x, float _y){
        x = _x;
        y = _y;
    }

    // Don't forget some tools we saw early on when
    // we learned D. 'typeof' will return the type
    //
    // -- typeof(this) explained --
    // of the object. 'this' is the internal pointer to
    // the instance of this function. So we can basically
    // use this nice trick of 'typeof(this')
    //
    // -- templates explained --
    // opBinary(template args)(function args)
    // Recall the first set of arguments are template arguments.
    // We can even put a type like 'op' to help save us some time.
    // We can then use 'static if' or 'mixin' at compile-time
    // to perform code generation and make our life easy.
    // You'll observe below that I use 'mixin' based on the 'op'
    // to effectively generate two versions of the function that
    // are otherwise identical, other than the operator.
    // A great time savings, and may help avoid mistakes!
    //
    // Speaking of mistakes, consider that for vectors we can
    // only do some operations like '+' and '-' are different than
    // scalar multiplication('*') and scalar division('\').
    //
    //
    // -- ref explained --
    // You'll observe the return type of 'ref' here.
    // Why not just return a new value and copy it?
    // Well, depending on the operation, it can be much
    // cheaper to return a reference. This technique also allows
    // for 'chaining' operations together, similar to what
    // UFCS allows us to do otherwise -- so you can do this with
    // other operations if you have the same type easily.
    ref typeof(this) opBinary(string op)(typeof(this) rhs){
        static if(op=="+" || op=="-")
        {
            mixin("x = x"~op~"rhs.x;");
            mixin("y = y"~op~"rhs.y;");
        }
        return this;
     }

    /*
    // This works the same as above, but makes and returns copies.
    // We generally want to avoid this
    typeof(this) opBinary(string op)(typeof(this) rhs){
        static if(op=="+" || op=="-")
        {
            typeof(this) result;
            mixin("result.x = x"~op~"rhs.x;");
            mixin("result.y = y"~op~"rhs.y;");
            return result;
        }
     }
     */
}

void main(){

    Vec2f v1 = Vec2f(1.0f,1.0f);
    Vec2f v2 = Vec2f(2.0f,2.0f);

    writeln("before v1:",v1);
    v1 = v1 + Vec2f(3.0f,3.0f) + v2;
    writeln("after v1:",v1);
    writeln("after v2:",v2); // unmodified
    
}	
```


## A few other random notes:

- I probably could have named our module something better than vec2.
     - In fact, it could be moved into a package, and we could split up a few functions.
     - For **simplicity** (so you only need to look in one file) it is otherwise perfectly fine to keep everything in vec2.
- Casting
     - Are you going to be casting everywhere in this library?
     - The answer is probably Yes -- so don't worry about it.  -- D is a bit more strict, and this is a good thing!
- opBinary versus opBinaryRight
     - `2 * v` is not the same thing as `v * 2` for our overloads.
          - That is going to 'bite you' if you don't know ahead of time that these are different.
     - For the purpose of this assignment, you can do everything without opBinaryRight. However, it may be useful to include the overloads (which are effectively a copy & paste for any commutative operation).
- opOpAssign is a confusing name, but stare at it for a moment.
	- 'op' is the operation, and then we also want to do an 'opAssign' after it. Basically this just means something like '+=' or '-=' (op is the +, and then do assignemnt (=) after).

### More on opBinaryRight?

Because not every operation in commutative. This is a superpower in the D language to make this very clear when operator overloading. At first I was annoyed by this myself, but then I realized it's much more clear to have two separate functions where order is not commutative. For 3D cross products for instance, this is especially important to make sure the wrong overload does not get called!

## How to compile and run your program

1. You can use simply run `dub test` file to build and run the project.
   - Note: `dub test` by default does a debug build.
   - Don't forget to use [gdb](https://www.youtube.com/watch?v=NWsZrN7gXYg) or [lldb](https://www.youtube.com/watch?v=drzvDkU-H54) if you run into errors!

# Submission/Deliverables

### Submission

- Commit all of your files to github, including any additional files you create.
- Do not commit any binary files unless told to do so.
- Do not commit any 'data' files generated when executing a binary.

### Deliverables

- A working math library that passes all of the unit tests.

# Going Further

An optional task(if any) that will reinforce your learning throughout the semester--this is not graded.

1. Want to implement more operations? No problem -- go for it!
        - Probably a good place to start is with various intersection functions.
        - At some point we'll implement AABB and OBB collision, but if you want to jump ahead go for it!

# F.A.Q. (Instructor Anticipated Questions)

1. Q: Can I build a package.d file and name it something better than 'vec2.d'?
    - A: Sure, but only if you promise me I can run `dub test` in part 0 and `dub` on part1 and 'it will just work'. :)
