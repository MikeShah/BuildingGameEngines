// @file function_pointer.d

int add(int a, int b){
	return a+b;
}
int sub(int a, int b){
	return a-b;
}

void main(){
	
	int function(int,int) operation;
	operation = &add;

	writeln(operation(7,2));

	operation = &sub;

	writeln(operation(7,2));

}
