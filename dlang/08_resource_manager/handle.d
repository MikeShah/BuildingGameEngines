import std.stdio,std.conv;
// A 'handle' which is simply an 'int' that is handed
// out by our resource manager.
alias ResourceHandle = int;

enum ResourceResult{
  INVALID_RESOURCE = -1,
}

// Type information for pre-defined resources
// that will be added to the reosurce manager.
enum ResourceType{
  Undefined = 0x0,
  Surface   = 0x1,
  Sound     = 0x2,
  SceneFile = 0x4, // NOTE: A Scene file could be a 'collection' of a bunch of
                   //       other resources
}

// The purpose of this struct is to store information about how
// to create a new instance of a type when 'load resource' is called.
struct ResourceCreationDefinition{
//    void* function(string) initializationFunc;
//    void* function(string) cleanUpFunciont;
  void* function(string)  factory;
}

struct Resource{
  static int     sNextHandle  = 0; 
  string         mName        = "unnamed";
  string         mFilePath    = "unknown path";
  void*          mData        = null;
  int            mDataSize    = 0;
  ResourceHandle mHandle      = -1;
  ResourceType   mType        = ResourceType.Undefined;
  int            mFlags       = 0 ;
  bool           mIsLoaded    = false;

  // Create a new resource 'lazily' -- nothing is actually loaded
  // at this point, only a resource handle that is named and reserved.
  this(ResourceType type, string name, string filepath, int flags){
    assert(name.length > 0, "Name cannot be an empty string");
    mName     = name;
    mFilePath = filepath;
    mHandle   = sNextHandle++;
    mType     = type;
    mFlags    = flags;
    mIsLoaded = false;
  }

  // Load a resource
  bool LoadResource(){
    bool result = false;
    if(mType !in sResourceLoaderMap){
      assert(false,"We do not know how to load resources of type: "~mType.to!string);
    }

    // Load data
    mData = sResourceLoaderMap[mType].factory(mFilePath);

    // If we loaded data successfully, toggle flag
    if(mData !is null){
      mIsLoaded = true;
    }

    // Return a false result if we failed to otherwise load data
    if(mData is null){
      result = false;
    }

    return result;
  }


  // Perform the actual loading of the resource. 
  bool LoadBinaryResource(const char* data, int size){
    // TODO:  Not implemented -- but the idea here is that
    //        you could stream in binary blobs of data from anywhere
    //        into the appropriate format.
    return true;
  }


  // ================================ Statics ===========================================

  // The resource loader map stores per type the functions on how to
  // load and create a resource.
  static ResourceCreationDefinition[int] sResourceLoaderMap;

  // Register a new way to create a resource
  static void RegisterResourceTypeInformation( int type, ResourceCreationDefinition def) {
    sResourceLoaderMap[type] = def;
  }
  // ================================ Statics ===========================================

}

struct ResourceManager{
  // The array of resources uses a 'handle' as the index and
  // returns the Resource.
  Resource[] mResourceArray;

  // Adds a new resource, and returns the handle.
  ResourceHandle AddResource(Resource res){
    ResourceHandle result = FindResource(res.mType,res.mName);
    if(result == ResourceResult.INVALID_RESOURCE){
      mResourceArray ~= res;
    }
    return res.mHandle;
  }

  // Finds a resource and returns the handle if it exists, otherwise returns -1 if
  // invalid
  //
  // NOTE: We use the 'name' and 'type' to check uniqueness as opposed to filename.
  //       This is because if I was streaming in data, I might not have a filepath,
  //       so it makes sense to just use the name.
  ResourceHandle FindResource(ResourceType type, string name){
    ResourceHandle result = ResourceResult.INVALID_RESOURCE;
    foreach(r ; mResourceArray){
      if(r.mType == type && r.mName == name){
        return r.mHandle;
      }
    }

    return result; 
  }

  // Loads all resource that are currently not loaded
  // TODO: You could have 'this be done 'async' or in parallel.
  bool LoadAllUnloadedResources(){
    bool result=true;
    foreach(ref r; mResourceArray){
      // Ignore already loaded resources
      if(r.mIsLoaded == true){ continue; }

      // Load resource and capture if the result returns false at least 1 time
      if(!r.LoadResource()){
        result = false;
      }
    }

    return result;
  }

  string toString(){
    string result;
    foreach(r ; mResourceArray){
      result ~= r.to!string ~ "\n";
    }
    return result;
  }
}

void* SDL_LoadBMP(string filename){
  writeln("SDL_LoadBMP:",filename);
  int* fakeData = new int;
  return fakeData;
}

void* LoadScene(string filename){
  writeln("LoadScene: ",filename);
  // Parse and load a scene
  return null;
}

// Program entry point
void main(){
  // Create a 'stub' or 'proxy'.
  // The idea here is that we will 'lazily load' resources.
  // As we collect the resources we need to load, we can premtively also disregard
  // any resources that we would not need to load
  Resource r1 = Resource(ResourceType.Surface,"main character","./assets/test.bmp",0);
  Resource r2 = Resource(ResourceType.Surface,"another surface","./assets/test2.bmp",0);
  Resource r3 = Resource(ResourceType.Surface,"another surface","./assets/test2.bmp",0);
  Resource r4 = Resource(ResourceType.Surface,"another surface2","./assets/test2.bmp",0);
  Resource r5 = Resource(ResourceType.SceneFile,"Some scene","./scenes/scene1.json",0);

  // For our resource manager, we then add all of our resources that we have initialized
  // NOTE: We might initialize resources manually as shown, but more likely we would
  //       be loading these from a structured file format rather than typing them out.
  ResourceManager manager = ResourceManager();
  manager.AddResource(r1);
  manager.AddResource(r2);
  manager.AddResource(r3);
  manager.AddResource(r4);
  manager.AddResource(r5);

  // We can DEBUG here to see that we should only have '2' real resources that are loaded
  writeln(manager);

  // Before loading our resources, I setup 'how-to' load up specific resources by
  // choosing which function calls handle how to load particular files.
  ResourceCreationDefinition surfaceResourceDef;
  ResourceCreationDefinition sceneResourceDef;
  surfaceResourceDef.factory  = &SDL_LoadBMP;
  sceneResourceDef.factory    = &LoadScene;

  // Register our new 'factory' for creating surface resources
  Resource.RegisterResourceTypeInformation(ResourceType.Surface,surfaceResourceDef);
  Resource.RegisterResourceTypeInformation(ResourceType.SceneFile,sceneResourceDef);

  // Load any unloaded resources
  manager.LoadAllUnloadedResources();
}
