module player;

// Load the SDL2 library
import bindbc.sdl;
import sprite;

struct Player{
    // Load our sprite
    Sprite mSprite;

    this(SDL_Renderer* renderer, string filepath){
        mSprite = Sprite(renderer,filepath);
    }

    int GetX(){
        return mSprite.mXPos;
    }
    int GetY(){
        return mSprite.mYPos;
    }

    void MoveUp(){
        mSprite.mYPos -=16;
        mSprite.mState = STATE.WALK;
    }
    void MoveDown(){
        mSprite.mYPos +=16;
        mSprite.mState = STATE.WALK;
    }
    void MoveLeft(){
        mSprite.mXPos -=16;
        mSprite.mState = STATE.WALK;
    }
    void MoveRight(){
        mSprite.mXPos +=16;
        mSprite.mState = STATE.WALK;
    }

    void Render(SDL_Renderer* renderer){
        mSprite.Render(renderer);
        mSprite.mState = STATE.IDLE;
    }
}
