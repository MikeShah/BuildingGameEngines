abstract class Monster{
	public:
		string getAttack();

	protected:
		int mHealth;
}

class Dragon : Monster{
	override string getAttack(){
		return "The dragon breathes fire!";
	}

}

class Troll : Monster{
	override string getAttack(){
		return "The troll clubs you!";
	}

}

void main(){

}
