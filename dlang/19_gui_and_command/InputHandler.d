// @file: InputHandler.d
class ComponentInput{
  
  void HandleInput(){
    if(isPressed(BUTTON_X)){
      jump();
    }
    else if(isPressed(BUTTON_Y)){
      fireProjectile();
    }else if(isPressed(BUTTON_Z)){
      duck();
    }
  }
}


void main(){

}


// Note: These lines of code are simply here to
//       help compile this example.
enum BUTTON_X = true;
enum BUTTON_Y = true;
enum BUTTON_Z = true;
void jump(){}
void fireProjectile(){}
void duck(){}
bool isPressed(bool b){return true;}
