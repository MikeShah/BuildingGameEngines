// @file: heroine.d
// An example showing problem of not having
// abstraction of state.
enum Input{PRESS_A,PRESS_B, PRESS_DOWN, KEY_RELEASED}

struct Heroine{

	float yVelocity;
	bool isJumping;
	bool isDucking;	

	void HandleInput(Input input){
			if(input == Input.PRESS_B){
					if(!isJumping && !isDucking){
						isJumping = true;
						yVelocity = 10.0f;
						// ... mSpriteComponent.SetGraphic("Jump Image");
					}
			}else if (input == Input.PRESS_DOWN){
					if(!isJumping){
						isDucking = true;
						// ... mSpriteComponent.SetGraphic("Ducking image");
					}else{
						isJumping = false;
						// ... mSetGraphics("Dive Attack down");
						// maybe need state for 'isDiving = true;'
					}
			}else if(input == Input.KEY_RELEASED){
				if(isDucking){
					isDucking = false;
					// mSpriteComponent.SetGraphic("Idle standing image");
				}
			}
	}
}




void main(){
}
