module tilemap;

// Load the SDL2 library
import bindbc.sdl;

/// DrawableTilemap is responsible for drawing 
/// the actual tiles for the tilemap data structure
struct DrawableTileMap{
    const int mMapXSize = 8;
    const int mMapYSize = 8;
 
    // Tile map with tiles
    TileSet mTileSet;

    // Static array for now for simplicity}
    int [mMapXSize][mMapYSize] mTiles;

    // Set the tileset
    this(TileSet t){
        // Set our tilemap
        mTileSet = t;

        // Set all tiles to 'default' tile
        for(int y=0; y < mMapYSize; y++){
            for(int x=0; x < mMapXSize; x++){
                if(y==0){
                   mTiles[x][y] = 33;
                } 
                else if(y==mMapYSize-1){
                    mTiles[x][y] =107;
                } 
                else if(x==0){
                    mTiles[x][y] =69;
                } 
                else if(x==mMapXSize-1){
                    mTiles[x][y] =71;
                } 
                else{
                    // Deafult tile
                    mTiles[x][y] = 966;
                }
            }
        }

        // Adjust the corners
        mTiles[0][0] = 32;
        mTiles[mMapXSize-1][0] = 34;
        mTiles[0][mMapYSize-1] = 106;
        mTiles[mMapXSize-1][mMapYSize-1] = 108;
    }
 
    void Render(SDL_Renderer* renderer, int zoomFactor=1){
        for(int y=0; y < mMapYSize; y++){
            for(int x=0; x < mMapXSize; x++){
                mTileSet.RenderTile(renderer,mTiles[x][y],x,y,zoomFactor);
            }
        }
    }

    // Specify a position local coorindate on the window
    int GetTileAt(int localX, int localY, int zoomFactor=1){
        int x = localX / (mTileSet.mTileSize * zoomFactor);
        int y = localY / (mTileSet.mTileSize * zoomFactor);

        if(x < 0 || y < 0 || x> mMapXSize-1 || y > mMapYSize-1 ){
            // TODO: Perhaps log error?
            // Maybe throw an exception -- think if this is possible!
            // You decide the proper mechanism!
            return -1;
        }

        return mTiles[x][y]; 
    }


}


/// Tilemap struct for loading a tilemap
/// and rendering tiles
struct TileSet{

        // Rectangle storing a specific tile at an index
		SDL_Rect[] mRectTiles;
        // The full texture loaded onto the GPU of the entire
        // tile map.
		SDL_Texture* mTexture;
        // Tile dimensions (assumed to be square)
        int mTileSize;
        // Number of tiles in the tilemap in the x-dimension
        int mXTiles;
        // Number of tiles in the tilemap in the y-dimension
        int mYTiles;

        /// Constructor
		this(SDL_Renderer* renderer, string filepath, int tileSize, int xTiles, int yTiles){
            mTileSize = tileSize;
            mXTiles   = xTiles;
            mYTiles   = yTiles;

			// Load the bitmap surface
			SDL_Surface* myTestImage   = SDL_LoadBMP(filepath.ptr);
			// Create a texture from the surface
			mTexture = SDL_CreateTextureFromSurface(renderer,myTestImage);
			// Done with the bitmap surface pixels after we create the texture, we have
			// effectively updated memory to GPU texture.
			SDL_FreeSurface(myTestImage);

            // Populate a series of rectangles with individual tiles
            for(int y = 0; y < yTiles; y++){
                for(int x =0; x < xTiles; x++){
                    SDL_Rect rect;
			        rect.x = x*tileSize;
        			rect.y = y*tileSize;
		        	rect.w = tileSize;
        			rect.h = tileSize;

                    mRectTiles ~= rect;
                }
            }
		}

        /// Little helper function that displays
        /// all of the tiles one after the other in an 
        /// animation. This is just a quick way to preview
        /// the tile
        void ViewTiles(SDL_Renderer* renderer, int x, int y, int zoomFactor=1){
            import std.stdio;

			static int tilenum =0;

            if(tilenum > mRectTiles.length-1){
				tilenum =0;
			}

            // Just a little helper for you to debug
            // You can omit this as necessary
            writeln("Showing tile number: ",tilenum);

            // Select a specific tile from our
            // tiemap texture, by offsetting correcting
            // into the tilemap
			SDL_Rect selection;
            selection = mRectTiles[tilenum];

            // Draw a preview of the actual tile
            SDL_Rect rect;
            rect.x = x;
            rect.y = y;
            rect.w = mTileSize * zoomFactor;
            rect.h = mTileSize * zoomFactor;

    	    SDL_RenderCopy(renderer,mTexture,&selection,&rect);
			tilenum++;
        }


        /// This is a handy helper function to tell you
        /// which tile your mouse is over.
        void TileSetSelector(SDL_Renderer* renderer){
            import std.stdio;
            
            int mouseX,mouseY;
            int mask = SDL_GetMouseState(&mouseX, &mouseY);

            int xTileSelected = mouseX / mTileSize;
            int yTileSelected = mouseY / mTileSize;
            int tilenum = yTileSelected * mXTiles + xTileSelected;
            if(tilenum > mRectTiles.length-1){
                return;
            }

            writeln("mouse  : ",mouseX,",",mouseY);
            writeln("tile   : ",xTileSelected,",",yTileSelected);
            writeln("tilenum: ",tilenum);

            SDL_SetRenderDrawColor(renderer, 255, 255, 255,255);

            // Tile to draw out on
            SDL_Rect rect = mRectTiles[tilenum];

            // Copy tile to our renderer
            // Note: We need a rectangle that's the exact dimensions of the
            //       image in order for it to render appropriately.
            SDL_Rect tilemap;
            tilemap.x = 0;
            tilemap.y = 0;
            tilemap.w = mXTiles * mTileSize;
            tilemap.h = mYTiles * mTileSize;
    	    SDL_RenderCopy(renderer,mTexture,null,&tilemap);
            // Draw a rectangle
            SDL_RenderDrawRect(renderer, &rect);

        }

        /// Draw a specific tile from our tilemap
		void RenderTile(SDL_Renderer* renderer, int tile, int x, int y, int zoomFactor=1){
            if(tile > mRectTiles.length-1){
                // NOTE: Could use 'logger' here to log an error
                return;
            }

            // Select a specific tile from our
            // tiemap texture, by offsetting correcting
            // into the tilemap
			SDL_Rect selection = mRectTiles[tile];

            // Tile to draw out on
            SDL_Rect rect;
            rect.x = mTileSize * x * zoomFactor;
            rect.y = mTileSize * y * zoomFactor;
            rect.w = mTileSize * zoomFactor;
            rect.h = mTileSize * zoomFactor;
 
            // Copy tile to our renderer
    	    SDL_RenderCopy(renderer,mTexture,&selection,&rect);
		}
}

