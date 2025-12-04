// @file: component.d
import std.stdio;

import gameobject;

shared static this(){
	GetIComponentDerivedClasses();
}

void GetIComponentDerivedClasses(){
	// Print out the components
	ClassInfo[] arr;
	string[] componentNames;
	foreach(mod; ModuleInfo){
		foreach(cl; mod.localClasses){
//			writeln("found cl: ",cl);	// Print out all classes from 'Module Info'
			if (cl.base is typeid(IComponent)){
				arr ~= cl;
//				IComponent t = new typeof(cl.base)();
				writeln("Name of object: ",cl.name);
				IComponent c = cast(IComponent)Object.factory(cl.name);
				componentNames ~= c.GetComponentName();
			}
		}
	}		
	writeln("arr: ",arr);
	writeln("componentNames: ",componentNames);
}

abstract class IComponent{
	// member functions that must be overriden
	void Update();
	string GetComponentName() const;
	// members variables
	GameObject* mOwner;
}

class ComponentTexture : IComponent{
	override string GetComponentName() const{ return "texture"; }

  this(){}

  this(uint width, uint height){
    mWidth = width;
    mHeight = height;
  }

	override void Update(){
		// Note: The 'cast' is so I can get the address and verify we
		//       have different components
		writeln("Updating Texture Component: ",cast(void*)this, "(", mWidth,",",mHeight,")");
	}
	private:
	uint mWidth, mHeight;
}

class ComponentCollider : IComponent{
	override string GetComponentName() const{ return "collider"; }

	override void Update(){
		// Note: The 'cast' is so I can get the address and verify we
		//       have different components
		writeln("Updating Collision Component: ",cast(void*)this);
	}
	private:
	float radius, x,y;
}

class ComponentAction: IComponent{
	override string GetComponentName() const{ return "action"; }

	import action;

	override void Update(){
		if(mActions.length >0){
			writeln("Running Actions Component: ",cast(void*)this);
			// Handle the first action until it is finished
			
			mActions[0].RunAction();
			if(mActions[0].mIsFinished){
				mActions = mActions[1 ..$];
			}
		}
	}

	void AddAction(IAction a){
		mActions ~= a;
	}

	private:
	IAction[] mActions;
}

IComponent ComponentFactory(string name){
	if(name=="texture"){
		return new ComponentTexture();
	}else if(name=="collider"){
		return new ComponentCollider();
	}else if(name=="action"){
		return new ComponentAction();	
	}else{
		GetIComponentDerivedClasses();
		assert(0, "Error, no component named:"~name);
	}
}
