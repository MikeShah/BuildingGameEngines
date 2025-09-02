// Standard libraries
import std.math;

// Third-party libraries
import bindbc.sdl;

float DegreesToRadians(float value){
	return value * PI / 180.0f;
}

struct ColliderCircle{
	float radius;
	float x,y;
	bool mColliding=false;	

	void Render(SDL_Renderer* render){
		// Set the render draw color based on the collision
		if(mColliding){
			SDL_SetRenderDrawColor(render,0,255,0,SDL_ALPHA_OPAQUE);
		}else{
			SDL_SetRenderDrawColor(render,255,0,0,SDL_ALPHA_OPAQUE);
		}

		for(float i=0; i < 360; i+=1){
				int xPos = cast(int)x+ cast(int)( radius*cos(i.DegreesToRadians) );
				int yPos = cast(int)y+ cast(int)( radius*sin(i.DegreesToRadians) );
				SDL_RenderPoint(render,xPos,yPos);	
		}
	}

	bool IsColliding(ref ColliderCircle c){
		float distance = sqrt( (x-c.x)*(x-c.x) + (y-c.y)*(y-c.y));
		if( (c.radius + radius) > distance){
			mColliding = true;
		}else{
			mColliding = false;
		}
		c.mColliding = mColliding;
		return mColliding;
	}
}
