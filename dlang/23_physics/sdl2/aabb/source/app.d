/// @file: /aabb/ 
import std.stdio;
import sdl_abstraction;
import bindbc.sdl;

/// Make an SDL Rectangle
SDL_Rect MakeRectangle(int x, int y, int w, int h){
		SDL_Rect rectangle;
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
						0,0, 640,480, SDL_WINDOW_SHOWN);

		// Create a hardware accelerated mRenderer
		SDL_Renderer* renderer = SDL_CreateRenderer(window,-1,SDL_RENDERER_ACCELERATED);

    // Make two rectangles
    SDL_Rect r1 = MakeRectangle(50,50,100,100);
    SDL_Rect r2 = MakeRectangle(50,50,100,100);


    // Store mouse positions
    int mouseX,mouseY;

		// Infinite loop for our application
		bool gameIsRunning=true;
		while(gameIsRunning){
				// Store an SDL Event
				SDL_Event event;
				// Handle input from our polled event.
				// Event is stored in the structure."q
				while(SDL_PollEvent(&event)){
						if(event.type == SDL_QUIT){
								writeln("Exit event triggered");
								gameIsRunning= false;
						}
						if(event.type == SDL_KEYDOWN){
								writeln("Pressed a key ");
						}
				}

        SDL_GetMouseState(&mouseX,&mouseY);
        r2.x = mouseX;
        r2.y = mouseY;


				// Set the render draw color 
				SDL_SetRenderDrawColor(renderer,100,190,255,SDL_ALPHA_OPAQUE);
				// Clear the renderer each time we render
				SDL_RenderClear(renderer);


        // Draw the rectangles
        SDL_Rect result;
        if(SDL_IntersectRect(&r1,&r2,&result)){
          // Fill in rectangle
          SDL_SetRenderDrawColor(renderer,255,255,255,SDL_ALPHA_OPAQUE);
          SDL_RenderFillRect(renderer, &result);
          // Set color of rectangles otherwise
          SDL_SetRenderDrawColor(renderer,255,0,0,SDL_ALPHA_OPAQUE);
        }else{
          SDL_SetRenderDrawColor(renderer,0,255,0,SDL_ALPHA_OPAQUE);
        }
        SDL_RenderDrawRect(renderer, &r1);
        SDL_RenderDrawRect(renderer, &r2);


				// Final step is to present what we have copied into
				// video memory
				SDL_RenderPresent(renderer);
		}
		// Destroy our renderer
		SDL_DestroyRenderer(renderer);
		// Destroy our window
		SDL_DestroyWindow(window);
} // end main()
