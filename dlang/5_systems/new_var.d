// @file new_var.d

void main(){
	// Allocate one variable on the heap
	// This value will be automatically reclaimed
	// by D's garbage collector.
	// D's garbage collector is built on top of the 'new' allocator
	int* data = new int;

}
