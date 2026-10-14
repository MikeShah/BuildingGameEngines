import bindbc.sdl;

// Store the application state
class AppState{
  SDL_Window* mWindow;
  SDL_Renderer* mRenderer;

  ~this(){
    // Destroy our renderer
    SDL_DestroyRenderer(mRenderer);
    // Destroy our window
    SDL_DestroyWindow(mWindow);
  }
}
