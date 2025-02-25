// @file: tree.d
// Interface for different tree traversal algorithms
interface ITraversalAlgorithm{
	void Traverse(TreeNode* start);
}
// Implementation of depth first search
class DepthFirstTraversal : ITraversalAlgorithm{
	void Traverse(TreeNode* start){
		/* ... */
	}
}
// Generic Node with n-number of children
struct TreeNode{
	TreeNode[] children;
}
// Main scene tree structure
struct SceneTree{
	// Call into the correct 'strategy' or 'algorithm'
	void Traverse(ITraversalAlgorithm strategy){
		strategy.Traverse(mRoot);
	}
	// Set the root
	void SetRoot(TreeNode* node){
		mRoot = node;
	}	
	// Root node
	TreeNode* mRoot;
}

void main(){
	TreeNode* n = new TreeNode();
	SceneTree s;
  s.SetRoot(n);	
	s.Traverse(new DepthFirstTraversal());
}

{
    "GameObjects": [
        {
            "name": "GameObject1",
            "ComponentTransform": {
                "x": 0,
                "y": 0,
                "z": 0,
                "sx": 50,
                "sy": 50,
                "angle": 90
            },
            "ComponentTexture": {
                "filename": "./assets/images/test.bmp"
            },
            "ComponentAnimation": {
                "filename": "./assets/images/test.json"
            }
        },
        {
            "name": "GameObject2",
            "ComponentTransform": {
                "x": 50,
                "y": 50,
                "z": 0,
                "sx": 50,
                "sy": 50,
                "angle": 90
            },
            "ComponentTexture": {
                "filename": "./assets/images/star.bmp"
            },
            "ComponentAnimation": {
                "filename": "./assets/images/test.json"
            }
        },
        {
            "name": "Tilemap",
            "ComponentTransform": {
                "x": 50,
                "y": 50,
                "z": 0,
                "sx": 50,
                "sy": 50,
                "angle": 90
            },
            "ComponentTileMap": {
                "filename": "./assets/images/star.bmp",
                "x": 0,
                "y": 0
            }
        }
    ]
}
