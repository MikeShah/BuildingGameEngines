/// @file: sdl_dub_examples/05_sdl_texture/app.d
import std.stdio;
import sdl_abstraction;
import bindbc.sdl;

void main()
{
		// Create na SDL Window
		SDL_Window* window = SDL_CreateWindow("Dlang SDL Window",640,480, SDL_WINDOW_ALWAYS_ON_TOP);

		// Create a hardware accelerated mRenderer
		SDL_Renderer* renderer = SDL_CreateRenderer(window,null);
		// Load the bitmap surface
		SDL_Surface* myTestImage   = SDL_LoadBMP("./assets/images/test.bmp");
		// Create a texture from the surface
		SDL_Texture* texture = SDL_CreateTextureFromSurface(renderer,myTestImage);
		// Done with the bitmap surface pixels after we create the texture, we have
		// effectively updated memory to GPU texture.
		SDL_DestroySurface(myTestImage);

		// Rectangle is where we will represent the shape.
		SDL_FRect rectangle;
		rectangle.x = 50;
		rectangle.y = 50;
		rectangle.w = 100;
		rectangle.h = 100;

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
				// Set the render draw color 
				SDL_SetRenderDrawColor(renderer,100,190,255,SDL_ALPHA_OPAQUE);
				// Clear the renderer each time we render
				SDL_RenderClear(renderer);

				// Copy a texture (or portion of a texture) to another
				// portion of video memory (i.e. a 2D grid of texels 
				// which span the width and height of the window)
				SDL_RenderTexture(renderer,texture,null,&rectangle);

				// Final step is to present what we have copied into
				// video memory
				SDL_RenderPresent(renderer);
		}
		// Free Video Memory
		SDL_DestroyTexture(texture);
		// Destroy our renderer
		SDL_DestroyRenderer(renderer);
		// Destroy our window
		SDL_DestroyWindow(window);
} // end main()
