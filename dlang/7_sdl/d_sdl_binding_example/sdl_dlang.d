// @file d_sdl_binding_example/sdl_dlang.d
// Compiling and running:
// dmd -betterC sdl_dlang.d sdl_manual_binding.d -L`pkg-config --libs sdl2` -of=prog && ./prog
//
// Note: I am intentionally using 'betterC' here to make this example more portable 
//
//
// The purpose of this example is to show how to 'bind' to a C library in a 
// relatively 'manual' way. There are tools to automate this process, but
// otherwise it shows what information the linker needs to know about in
// order to process various commands.
//
// Some resources:
// https://dlang.org/spec/interfaceToC.html
// https://wiki.dlang.org/D_binding_for_C#Introduction
// https://p0nce.github.io/d-idioms/#Linking-with-C-gotchas
// https://p0nce.github.io/d-idioms/#Porting-from-C-gotchas
import core.stdc.stdio;
import sdl_manual_binding;
                                                    
extern (C) void main(){
    SDL_Window* window;

    if(SDL_Init(SDL_INIT_VIDEO) <0){
       printf("Could not initialize SDL Video\n"); 
    }

    window = SDL_CreateWindow("A Full SDL Program with D Binding", 0,0, 800,600,SDL_WINDOW_SHOWN);
	if(null==window){ printf("Could not create window\n");  }

    SDL_Renderer* renderer = null; 
    renderer = SDL_CreateRenderer(window,-1,SDL_RENDERER_ACCELERATED);

    SDL_Surface* surface = SDL_LoadBMP("./assets/test.bmp"); 
	SDL_SetColorKey(surface,true,SDL_MapRGB(surface.format,0xFF,0,0xFF));

    SDL_Texture* texture = SDL_CreateTextureFromSurface(renderer,surface);                                              
    SDL_FreeSurface(surface);
                                                                                                                            
    // Create a rectangle                                                                                                   
    SDL_Rect rectangle;                                                                                                     
    rectangle.x = 50;                                                                                                       
    rectangle.y = 100;                                                                                                      
    rectangle.w = 200;                                                                                                       
    rectangle.h = 200;   

    // Infinite loop for our application                                                                                    
    bool gameIsRunning = true;                                                                                              
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
			
			if(event.type == SDL_MOUSEBUTTONDOWN){
				if(event.button.button == SDL_BUTTON_LEFT){
					SDL_SetTextureBlendMode(texture,SDL_BLENDMODE_ADD);
				}
			}                                                                     
        }                                                                                                                   
        // (2) Handle Updates                                                                                               
                                                                                                                            
        // (3) Clear and Draw the Screen                                                                                    
        // Gives us a clear "canvas"                                                                                        
        SDL_SetRenderDrawColor(renderer,0,0,0,SDL_ALPHA_OPAQUE);                                                            
        SDL_RenderClear(renderer);                                                                                          
                                                                                                                            
        // Do our drawing                                                                                                   
        SDL_SetRenderDrawColor(renderer,255,255,255,SDL_ALPHA_OPAQUE);                                                      
        SDL_RenderDrawLine(renderer,5,5,100,120);                                                                           
                                                                                                                            
        SDL_RenderDrawRect(renderer,&rectangle);                                                                            
		SDL_RenderCopy(renderer,texture,null,&rectangle);
        // Finally show what we've drawn                                                                                    
        SDL_RenderPresent(renderer);                                                                                        
    }	

	SDL_DestroyTexture(texture);
	SDL_DestroyRenderer(renderer);
	SDL_DestroyWindow(window);
	SDL_Quit();
}

