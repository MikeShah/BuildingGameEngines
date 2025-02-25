// mixin_example3.d

// mixin templates are a great tool for any 
// boilerplate that you may want to create.
mixin template GenerateGetterSetter(T, bool Getter=true, bool Setter=true){
		import std.stdio;
		import std.traits;
		import std.range;
		// Iterate through every member variable
		import std.meta;

		// Store fields types in AliasSequence
		alias myFieldTypes = AliasSeq!(Fields!T);
		static foreach(idx, member; FieldNameTuple!T   ){
				// Generate the code for each of the 'Getter' functions
				static if(Getter == true){
						mixin(myFieldTypes[idx].stringof~" get"~member~"(){ return "~member ~";}");
				}
				static if(Setter == true){
						mixin("void set"~member~"("~myFieldTypes[idx].stringof~" _val){ this."~member~" = _val;}");
				}
		}
}

// Example struct where we can use our mixin template
struct SomeType{
		int   IntField;
		float FloatField;

		mixin GenerateGetterSetter!(SomeType,true,true);
}

void main(){
		import std.stdio;

		SomeType s;

		s.setIntField(5);
		s.setFloatField(17.1f);

		writeln("s.getIntField()  : ",s.getIntField());
		writeln("s.getFloatField(): ",s.getFloatField());
}
