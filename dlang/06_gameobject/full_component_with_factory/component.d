// @file: full_component/component.d
import std.stdio;

enum ComponentType{TEXTURE,COLLISION,AI,SCRIT};

interface IComponent{
	void Update();
}

class ComponentTexture : IComponent{
	this(size_t owner){
		mOwner = owner;
	}
	~this(){}
	override void Update(){
		// Note: The 'cast' is so I can get the address and verify we
		//       have different components
		writeln("\tUpdating Texture: ",cast(void*)this);
	}

	private:
	size_t mOwner;
	uint mWidth, mHeight;
}

class ComponentCollision : IComponent{
	this(size_t owner){
		mOwner = owner;
	}
	~this(){}
	override void Update(){
		// Note: The 'cast' is so I can get the address and verify we
		//       have different components
		writeln("\tUpdating Collision: ",cast(void*)this);
	}

	private:
	size_t mOwner;
	float radius, x,y;
}
