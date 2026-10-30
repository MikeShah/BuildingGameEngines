/// @file: /aabb/ 
import std.stdio;
import sdl_abstraction;
import bindbc.sdl;

/// Make an SDL Rectangle
SDL_FRect MakeRectangle(float x, float y, float w, float h){
		SDL_FRect rectangle;
		rectangle.x = x;
		rectangle.y = y;
		rectangle.w = w;
		rectangle.h = h;
    return rectangle;
}



void main()
{
		// Create na SDL Window
		SDL_Window* window = SDL_CreateWindow("Dlang SDL Window",
						640,480, SDL_WINDOW_ALWAYS_ON_TOP);

		// Create a hardware accelerated mRenderer
		SDL_Renderer* renderer = SDL_CreateRenderer(window,null);

    // Make two rectangles
    SDL_FRect r1 = MakeRectangle(50,50,100,100);

    // Store mouse positions
    float mouseX,mouseY;

		// Infinite loop for our application
		bool gameIsRunning=true;
		while(gameIsRunning){
				// Store an SDL Event
				SDL_Event event;
				// Handle input from our polled event.
				// Event is stored in the structure."q
				while(SDL_PollEvent(&event)){
						if(event.type == SDL_EVENT_QUIT){
								writeln("Exit event triggered");
								gameIsRunning= false;
						}
						if(event.type == SDL_EVENT_KEY_DOWN){
								writeln("Pressed a key ");
						}
				}

        SDL_GetMouseState(&mouseX,&mouseY);


				// Set the render draw color 
				SDL_SetRenderDrawColor(renderer,100,190,255,SDL_ALPHA_OPAQUE);
				// Clear the renderer each time we render
				SDL_RenderClear(renderer);


        // Find location of intersection
        // Store somewhere a copy of the line, this will get clipped if there's
        // an intersection
        float x1 = 0;
        float y1 = 0;
        float x2 = mouseX;
        float y2 = mouseY;
        // Perform the intersection
        if(SDL_GetRectAndLineIntersectionFloat(&r1,&x1,&y1,&x2,&y2)){
          // Draw line from origin to mouse position
          SDL_SetRenderDrawColor(renderer,255,0,0,SDL_ALPHA_OPAQUE);
          SDL_RenderLine(renderer,0,0,x1,y1);

          // If values change, then draw a box on the side of the new value
          //          if(x2 != mouseX && y2 != mouseY){
          SDL_FRect collision = MakeRectangle(x1,y1,8,8);
          SDL_RenderRect(renderer, &collision);
          //        }

          // Set color of rectangles otherwise
          SDL_SetRenderDrawColor(renderer,255,0,0,SDL_ALPHA_OPAQUE);
        }else{
          SDL_SetRenderDrawColor(renderer,0,255,0,SDL_ALPHA_OPAQUE);
          SDL_RenderLine(renderer,0,0,mouseX,mouseY);
        }
        SDL_RenderRect(renderer, &r1);


				// Final step is to present what we have copied into
				// video memory
				SDL_RenderPresent(renderer);
		}
		// Destroy our renderer
		SDL_DestroyRenderer(renderer);
		// Destroy our window
		SDL_DestroyWindow(window);
} // end main()
