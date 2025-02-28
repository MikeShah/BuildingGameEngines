/// new and delete cannot be overloaded, but you can otherwise
/// add new functions to directly call malloc.
/// Idea would otherwise be to have a class or 'scoped' allocator
/// to pick up some memory.
import std.stdio;
import core.stdc.stdlib;

struct A{
	int a,b;
}

struct B{
	char a,b;
}

interface IAllocator{
	void* NEW(size_t size);
	void DELETE(void* mem);
}

class test : IAllocator{
		string[long] block;	// Keep a map of all allocations

		~this(){
			/// TODO: Iterate through blocks and remove
			///			  or report any blocks that were not freed.
		}

		void* NEW(size_t size){
			import core.stdc.stdlib;
			/// Note: We would not in practice use malloc,
			///			  We should use mmap and maintain the block list.
			/// 			Wrapping malloc would not give us any performance boost,
			///       though it could be useful to otherwise report memory leaks.
			void* memory = cast(void*)malloc(size);

			block[cast(long)memory] = "allocated";
			return memory;
		}

		void DELETE(void* mem){
			if(cast(long)mem in block){
				writeln("Found a block of memory previously allocated");
				free(mem);
				// TODO Remove block from map
			}
			// TODO: Handle case of what to do if memory not there.
		}
	
}


int main(){
		test allocator = new test;;

    writeln("new A: ");
    A* a = cast(A*)allocator.NEW(A.sizeof);

    writeln("new B: ");
    B* b = cast(B*)allocator.NEW(B.sizeof);

		allocator.DELETE(b);

    return 0;
}
