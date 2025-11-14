module vec3;

/// Vec3
struct Vec3{
		float x,y,w;

		Vec3 opCast(float[3] f){
				x = f[0];
				y = f[1];
				w = f[2];
				return this;
		}
}

/// Dot product of a vector 3
float Dot3(Vec3 v1, Vec3 v2){
		return (v1.x *v2.x) + (v1.y*v2.y) + (v1.w * v2.w);
}


