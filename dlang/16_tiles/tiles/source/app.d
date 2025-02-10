/// Run with: 'dub'

module app;

// Import D standard libraries
import std.stdio;
import std.string;

//import setup_sdl;
import sprite;
import tilemap;
import player;

// Load the SDL2 library
import bindbc.sdl;


interface Command{
    void Execute();
    void Undo();
}

class MoveSprite : Command {
    override void Execute(){}
    override void Undo() {}
}


// Entry point to program
void main()
{
    writeln("Arrowkeys to move, hold 'space' key for tile map selctor demo"); 
    // Create an SDL window
    SDL_Window* window= SDL_CreateWindow("D SDL Tilemap Example",
                                        SDL_WINDOWPOS_UNDEFINED,
                                        SDL_WINDOWPOS_UNDEFINED,
                                        640,
                                        480, 
                                        SDL_WINDOW_SHOWN);
    // Create a hardware accelerated renderer
    SDL_Renderer* renderer = null;
    renderer = SDL_CreateRenderer(window,-1,SDL_RENDERER_ACCELERATED);

    // Load our tiles from an image
    TileSet ts = TileSet(renderer, "./assets/kenney_roguelike-modern-city/Tilemap/tilemap_packed.bmp", 16,37,28);
    DrawableTileMap dt = DrawableTileMap(ts);

    // Create our player
    Player player = Player(renderer, "./assets/images/test.bmp");

    // Infinite loop for our application
    bool gameIsRunning = true;

    // How 'zoomed' in are we
    int zoomFactor =3;

    // Main application loop
    while(gameIsRunning){
        SDL_Event event;

        // (1) Handle Input
        // Start our event loop
        while(SDL_PollEvent(&event)){
            // Handle each specific event
            if(event.type == SDL_QUIT){
                gameIsRunning= false;
            }
        }

        // Get Keyboard input
        const ubyte* keyboard = SDL_GetKeyboardState(null);

        int playerX = player.GetX();
        int playerY = player.GetY();

        // Check if it's legal to move a direction
        // TODO: Consider moving this into a function
        //       e.g. 'legal move'
        bool moveLeft   = dt.GetTileAt(playerX-16,playerY,zoomFactor)==966? true : false;
        bool moveRight  = dt.GetTileAt(playerX+16,playerY,zoomFactor)==966? true : false;
        bool moveUp     = dt.GetTileAt(playerX,playerY-16,zoomFactor)==966? true : false;
        bool moveDown   = dt.GetTileAt(playerX,playerY+16,zoomFactor)==966? true : false;

        // Check for movement
        if(keyboard[SDL_SCANCODE_LEFT] && moveLeft){ 
            player.MoveLeft();
        }
        if(keyboard[SDL_SCANCODE_RIGHT] && moveRight){
            player.MoveRight();
        }
        if(keyboard[SDL_SCANCODE_UP] && moveUp){
            player.MoveUp();
        }
        if(keyboard[SDL_SCANCODE_DOWN] && moveDown){
            player.MoveDown();
        }

        // (2) Handle Updates

        // (3) Clear and Draw the Screen
        // Gives us a clear "canvas"
        SDL_SetRenderDrawColor(renderer,100,190,255,SDL_ALPHA_OPAQUE);
        SDL_RenderClear(renderer);

        // NOTE: The draw order here is very important
        //       We follow the 'painters algorithm' in 2D
        //       meaning that we draw the background first,
        //       and then our objects on top.

        // Render out DrawableTileMap
        dt.Render(renderer,zoomFactor);

        // Draw our sprite
        player.Render(renderer);
       
        // Draw the tile preview just so we can see all the different tiles in the tile map
        // ts.ViewTiles(renderer,480,400,8);

        if(keyboard[SDL_SCANCODE_SPACE]){
            ts.TileSetSelector(renderer);
        }

        // Little frame capping hack so we don't run too fast
        SDL_Delay(125);

        // Finally show what we've drawn
        // (i.e. anything where we have called SDL_RenderCopy will be in memory and presnted here)
        SDL_RenderPresent(renderer);
    }


    // Destroy our window
    SDL_DestroyWindow(window);
}
