// @file: command_pattern_buttons.d
interface Command{
  int Execute();
  int Undo();
}

class JumpCommand : Command{
  this(){ }
  override void Execute(){  writeln("Jumping"); }
}
class FireCommand : Command{
  this(){ }
  override void Execute(){  writeln("Firing"); }
}
class DuckCommand : Command{
  this(){ }
  override void Execute(){  writeln("Ducking"); }
}

class ComponentInput{

  Command ButtonX;
  Command ButtonY;
  Command ButtonZ;

  void HandleInput(){
    if(isPressed(BUTTON_X)){
      ButtonX.Execute();  
    }
    else if(isPressed(BUTTON_Y)){
      ButtonY.Execute();
    }else if(isPressed(BUTTON_Z)){
      ButtonZ.Execute();
    }
  }
}
void main(){
  ComponentInput input = new ComponentInput;
  input.ButtonX = new JumpCommand();
  input.ButtonY = new FireCommand();
  input.ButtonZ = new DuckCommand();

}

