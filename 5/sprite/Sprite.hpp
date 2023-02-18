// sprite/Sprite.hpp
#pragma once


class Sprite{
    public:
        // Constructor
        Sprite();
        // Destructor
        ~Sprite();
        // Copy Constructor
        Sprite(const Sprite& rhs);

    private:
        // Components of a 'Sprite'
        // A Sprite consists of the texture (when rendering on GPU)
        // and a Position in the world.
        Vec2D           mPosition;
        SDL_Texture*    mTexture;

        // Note: We could have other attributes part of the sprite
        //       e.g. 'unique id', 'z-layer' (for render order), etc.
};



