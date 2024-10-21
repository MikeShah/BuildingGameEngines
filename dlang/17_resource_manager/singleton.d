// @file singleton.d
struct Image{
    string filename;
    ubyte[] pixels;
}

struct ResourceManager{

    static ResourceManager* GetInstance(){
        if(mInstance is null){
            mInstance = new ResourceManager();
        }
        return mInstance;
    }

    static Image* LoadImageResource(string filename){
        if(filename in mImageResourceMap){
            return mImageResourceMap[filename];
        }else{
            return null;
        }
    }

    private:
        static ResourceManager* mInstance;
        static Image*[string] mImageResourceMap;
}

void main(){
    ResourceManager.GetInstance().LoadImageResource("myImage.bmp");
}
