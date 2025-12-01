// @file: typeobject_pattern.d
import std.stdio;

// Note: The interface is not strictly necessary, but it is a
//       very useful tool to ensure we have matching functionality.
interface MonsterBreedTypes{
	int GetHealth();
	string GetAttack();
}

class Breed : MonsterBreedTypes{
	this(int health, string attack){
		this.mHealth = health;
		this.mAttack = attack;
	}

	override int GetHealth() const{
		return mHealth;
	}

	override string GetAttack() const{
		return mAttack;
	}

	private:
		int mHealth;
		string mAttack;
}

class Monster : MonsterBreedTypes{
	this(Breed breed){
		// Hold a reference to the breed if it changes.
		this.mBreed = breed;
		this.mHealth = breed.GetHealth();
	}

	override int GetHealth() const{
		return mHealth;
	}
	string GetAttack(){
		return mBreed.GetAttack();
	}

	private:
		int mHealth;	// Current Health
		Breed mBreed;
}


void main(){

	Breed dragon = new Breed(100,"Dragon breathes fire!");

	Breed troll = new Breed(10, "Troll attacks with club!");

	Monster monster1 = new Monster(dragon);
	Monster monster2 = new Monster(troll);

	writeln(monster1.GetAttack());
	writeln(monster2.GetAttack());
}
