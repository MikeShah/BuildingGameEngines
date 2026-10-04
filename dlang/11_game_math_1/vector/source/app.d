/// Run with: 'dub'

// Import D standard libraries
import std.stdio, std.string, std.conv, std.math;

// Load the SDL3 library
import bindbc.sdl;
import sdl_abstraction;

void DrawGrid(SDL_Renderer* renderer, int size, int w, int h){
  SDL_SetRenderDrawColor(renderer,64,64,64,255);
  for(int y=0; y < h/size; y++){
    for(int x=0; x < w/size; x++){
        SDL_RenderLine(renderer,x*size,0,x*size,h);
        SDL_RenderLine(renderer,0,y*size,w,y*size);
    }
  }

}


// Entry point to program
void main()
{
    // Create an SDL window
    SDL_Window* window= SDL_CreateWindow("D SDL Vector",
                                        640,
                                        480, 
                                        SDL_WINDOW_ALWAYS_ON_TOP | SDL_WINDOW_RESIZABLE);

		// Create a hardware accelerated renderer
		SDL_Renderer* renderer = null;
		renderer = SDL_CreateRenderer(window,null);

    // Infinite loop for our application
    bool gameIsRunning = true;
    float originX = 320;
    float originY = 240;
    float windowWidth  = 640;
    float windowHeight = 480;

    // Main application loop
    while(gameIsRunning){
        SDL_Event event;

        // (1) Handle Input
        // Start our event loop
        while(SDL_PollEvent(&event)){
            // Handle each specific event
            if(event.type == SDL_EVENT_QUIT){
                gameIsRunning= false;
            }
            if(event.type == SDL_EVENT_WINDOW_RESIZED){
              // Handle the resizing of a winodw
              windowWidth  = event.window.data1;
              windowHeight = event.window.data2;
              originX = windowWidth/2;
              originY = windowHeight/2;
              SDL_SetRenderLogicalPresentation(renderer, event.window.data1,event.window.data2, SDL_LOGICAL_PRESENTATION_LETTERBOX);
            }
        }
        // (2) Handle Updates

        // (3) Clear and Draw the Screen
        // Gives us a clear "canvas"
        SDL_SetRenderDrawColor(renderer,0,0,0,SDL_ALPHA_OPAQUE);
        SDL_RenderClear(renderer);

        DrawGrid(renderer,10,cast(int)windowWidth,cast(int)windowHeight);

        // Do our drawing

        // Set draw color for our line
        SDL_SetRenderDrawColor(renderer,255,255,255,SDL_ALPHA_OPAQUE);
        float mx,my;
        SDL_GetMouseState(&mx,&my);
        SDL_RenderLine(renderer,originX,originY,mx,my);

        // Print out mouse coordinates.
        string vectorText = "mouse: ("~mx.to!string~","~my.to!string~")";
        string cartesian= "cartesian mouse: ("~(mx-originX).to!string~","~(-my+originY).to!string~")";
        // Print out the angle if the top-left corner is the origin.
        // Probably NOT what we want however.
        string vectorAngleTextTopLeft = "Not Correct (Angle if origin is top-left): "~(atan2(my,mx)*57.2958).to!string;
        //180/pi is around 57.2958
        string vectorAngleTextMath = "Correct Angle (if origin is centered)  : "~(atan2(my-originY,mx-originX)*57.2958).to!string;
        // Render some debug text
        SDL_SetRenderDrawColor(renderer,255,0,0,SDL_ALPHA_OPAQUE);
        SDL_SetRenderScale(renderer, 1.5f, 1.5f);
        SDL_RenderDebugText(renderer, 10,10,vectorText.toStringz ) ;
        SDL_RenderDebugText(renderer, 10,20,cartesian.toStringz ) ;
        SDL_RenderDebugText(renderer, 10,30,vectorAngleTextTopLeft.toStringz ) ;
        SDL_RenderDebugText(renderer, 10,40,vectorAngleTextMath.toStringz ) ;
        SDL_SetRenderScale(renderer, 1.0f, 1.0f);

        // Finally show what we've drawn
        SDL_RenderPresent(renderer);

    }


    // Destroy our window
    SDL_DestroyWindow(window);
}
