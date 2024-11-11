// @file: gameobject.d

interface IComponent{}
class Scripts : IComponent {}


struct GameObject{
	uint mID;
	bool isStaticGameObject = true;

	IComponent[] components;
	Scripts[]    scripts;
}


void main(){}
