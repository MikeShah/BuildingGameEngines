// @file: GameObject_tree.d
struct Mat3{  float[9] e; }
class ComponentTransform{  
  Mat3 mLocalTransform; 
  Mat3 mWorldTransform; 
}

class GameObject{
  string       mName;
  GameObject   mParent;
  GameObject[] mChildren;
  ComponentTransform  mTransform;  

  this(string name){ mName = name; }

  void AddChild(GameObject g){
    g.mParent = this; // This object is the parent.
    mChildren ~= g;   // Add to children list.
  }
}

void TraverseTree(GameObject root) { 
  foreach(child ; root){
    // multiply local child transfrom matrix 
    // by parent world transform and store in
    // child world transform.
  } 
}

void main(){
  GameObject g = new GameObject("root");
  g.AddChild(new GameObject("child node"));
}
