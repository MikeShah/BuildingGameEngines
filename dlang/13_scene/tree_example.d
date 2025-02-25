// @file: tree_example.d
import std.stdio;
// Generic Node with n-number of children
struct TreeNode{
	TreeNode[] mChildren;
	int mLevel;
	int mParentID;
	int mNodeID;
	int mData;

	this(int data){
		static uniqueID=9000;
		mData = data;
		mNodeID = ++uniqueID;
	}

	void AddChild(int data){
		TreeNode t = TreeNode(data);
		t.mParentID = this.mParentID;
		t.mLevel = this.mLevel + 1;
		mChildren ~= t;
	}

	// Visualize the tree with indentation
	// Another way might be to 'serialize' the tree
	// and it would look something like:
	// 99 [ 1 2 [ 4 5 6 7 ] 3 ]
	void Visualize(){
		import std.range;
			string indent;
			for(int i=0; i < mLevel; i++){ indent ~= " "; }
			writeln(indent,mData);
	}
}

// Main scene tree structure
struct SceneTree{
	// Traverse the scene tree
	void Traverse(){
			TreeNode[] q;	
			// Append the first node	
			q ~= [*mRoot];
			for(TreeNode node; q.length > 0; ){
				// Get the first node 
				node = q[0];				

				node.Visualize();
				// Pop off the node we have visited 
				q = q[1 .. $];
				q = node.mChildren ~ q;
			}
	}
	// Set the root
	void SetRoot(TreeNode* node){
		mRoot = node;
	}	
	// Root node
	TreeNode* mRoot;
}

void main(){

	SceneTree s;
	TreeNode* n = new TreeNode(99);
  s.SetRoot(n);	

	n.AddChild(1);
	n.AddChild(2);
	n.AddChild(3);

	// Retrieve a child from our root, and 
	// add some more children
	TreeNode* middleChild = &n.mChildren[1];
	middleChild.AddChild(4);
	middleChild.AddChild(5);
	middleChild.AddChild(6);
	middleChild.AddChild(7);



	s.Traverse();
}
