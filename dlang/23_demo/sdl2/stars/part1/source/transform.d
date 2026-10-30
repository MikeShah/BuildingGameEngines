import matrix;
import vec2;
import std.math;

// Supply a 'screen' or 'pixel' location in the window, and get
// back a world location
Vec2f ScreenToWorld(float x, float y, float w, float h){
		Vec2f world;            

		float middleWidth = w/2.0;
		float middleHeight = h/2.0;

		world.x = cast(int)((x - middleWidth));
		world.y = cast(int)((middleHeight - y));

		return world;
}

// w = width of window
// h = height of window
// x = screen pixel coordinate
// y = screen pixel coordinate y location
Vec2f WorldToScreenCoordinates(float x, float y, float w, float h){
		Vec2f screen;            

		float middleWidth = w/2.0;
		float middleHeight = h/2.0;

		screen.x = cast(int)((middleWidth + x));
		screen.y = cast(int)((middleHeight - y));

		return screen;
}

