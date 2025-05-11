module linear.collision;
import linear;


bool Intersect(Rectangle a, Rectangle b){
		/// Check along some interval if 
		/// there is an overlap
		bool Intersect1D(float minA, float maxA, float minB, float maxB){
				return minB <= maxA &&
						minA <= maxB;
		}

		// Check if any portion of 'a' falls within 'b'
		bool xaxis = Intersect1D(a.corner.x, a.corner.x + a.size.x, b.corner.x, b.corner.x + b.size.x);

		bool yaxis = Intersect1D(a.corner.y, a.corner.y + a.size.y, b.corner.y, b.corner.y + b.size.y);
		return xaxis && yaxis;
}

bool Intersect(Circle a, Circle b){
		float radiusSum = a.radius + b.radius;
		vec2 centers = a.center - b.center;

		return centers.Length() <= radiusSum;
}

bool Intersect(Point a, Point b){
		return a==b;
}

bool Intersect(Ray a, Ray b){
		assert(0,"Not yet implemented, just need to check direction, if overlapping, and if parallel");
}

bool Intersect(LineSegment a, LineSegment b){

}

