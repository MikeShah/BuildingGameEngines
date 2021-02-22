// Not production level code, bun experiment!
//
//
// You will compile this source using the following:
// 
// clang++ -std=c++14 -mavx2 -mfma dot.cpp -o dotproduct
// 
// clang++ - the compiler
// -std=c++14 - use c11 standard
// -mavx2 - use avx2 library
// -mfma - enable fused-multiply add extensions 
//
// Run as normal with: 
// 
// ./dotproduct
//
//
//  Additional links of interest: http://en.cppreference.com/w/cpp/algorithm/inner_product
//
//
//  rdtsc() instruction usage: https://msdn.microsoft.com/en-us/library/twchhe95.aspx
//
#include <stdio.h>
// Intrinsicts library
#include <immintrin.h>

#include <iostream>
#include <random>
#include <chrono>


#pragma intrinsic(__rdtsc) 

struct Vector3{
	float x,y,z,w; // '4th value' is not really used here, just padding to 128 bits
};


// Computes the dot product of a three-dimensional vector
float AVX_Vector3DotProduct1(const Vector3& a, const Vector3& b){
	// Convert each 'float' into a simd type	
	// Note that the values are not 'backwards'
	// Well, at least not on my machine. Why? (hint: Endianness)
	// Here is a brute force way to do it
	// This will be sort of slow however.
	__m128 v1 = _mm_set_ps(0.0, a.z, a.y, a.x);
	__m128 v2 = _mm_set_ps(0.0, b.z, b.y, b.x);
	__m128 resultVec = _mm_setzero_ps();

	__m128 result = _mm_fmadd_ps(v1,v2,resultVec);
	
	// Now let's print out the vector
	float* f = (float*)&result;
 	// printf("%f %f %f %f\n", f[3],f[2],f[1],f[0]); // Uncomment if you want to debug
	return f[0];
}

// Computes the dot product of a three-dimensional vector
float AVX_Vector3DotProduct2(const Vector3& a, const Vector3& b){
	// Same pattern as before, with the load command.
	// We can use the load command to load values from our struct.
	__m128 v1 = _mm_load_ps(&a.x); // This code is equivalent // _mm_set_ps(0.0, a.z, a.y, a.x);
	__m128 v2 = _mm_load_ps(&b.x); // This code is equivalent // _mm_set_ps(0.0, b.z, b.y, b.x);
	__m128 resultVec = _mm_setzero_ps();
	// This is new, a 'fused multiply and add'
	// This is helps us achieve 'dot product'
	__m128 result = _mm_fmadd_ps(v1,v2,resultVec);

	// Now let's print out the vector
	float* f = (float*)&result;
 	// printf("%f %f %f %f\n", f[3],f[2],f[1],f[0]); // Uncomment if you want to debug
	return f[0];
}

// Computes the dot product of a three-dimensional vector
float AVX_Vector3DotProduct3(const Vector3& a, const Vector3& b){

	// Luckily, we can use the load command to load values from our struct.
	__m128 v1 = _mm_load_ps(&a.x); // This code is equivalent // _mm_set_ps(0.0, a.z, a.y, a.x);
	__m128 v2 = _mm_load_ps(&b.x); // This code is equivalent // _mm_set_ps(0.0, b.z, b.y, b.x);

	__m128 result = _mm_dp_ps(v1,v2,0xFF);		
	
	// Now let's print out the vector
	float* f = (float*)&result;
 	// printf("%f %f %f %f\n", f[3],f[2],f[1],f[0]); // Uncomment if you want to debug
	return f[0];
}

// Regular dot product
// Computes the dot product of a three-dimensional vector
float Vector3DotProduct(const Vector3& a, const Vector3& b){
 	// printf("%f %f %f\n", a.x*b.x,a.y*b.y,a.z*b.z); // Uncomment if you want to debug
	// printf("actual = %f\n", (a.x*b.x + a.y*b.y + a.z*b.z));
	return (a.x*b.x + a.y*b.y + a.z*b.z);
}




int main(){

	// What is constexpr? (Sort of like const, but something else happens at compile-time!)
	constexpr int trials = 100000;
	Vector3 Vector1[trials];
	Vector3 Vector2[trials];
	float results[trials];
	float avxresults1[trials];
	float avxresults2[trials];
	float avxresults3[trials];

	std::cout << "Beginning test!\n";
	std::cout << "\nTotal Trials for each:" << trials << "\n";		
	// Precompute a bunch of floats
	// source: http://en.cppreference.com/w/cpp/numeric/random/uniform_real_distribution
	std::random_device rd;
	std::mt19937 gen(rd());
	std::uniform_real_distribution<> dis(1.0,2.0);

	for(int i =0; i < trials; ++i){
		Vector1[i].x = dis(gen);
		Vector1[i].y = dis(gen);
		Vector1[i].z = dis(gen);
		Vector2[i].x = dis(gen);
		Vector2[i].y = dis(gen);
		Vector2[i].z = dis(gen);
	} 
	
	// Experiment 1
	std::chrono::steady_clock::time_point start1; 	long long start1ticks;
	std::chrono::steady_clock::time_point end1;	long long end1ticks;
	
	// Perform the trials
	start1 = std::chrono::steady_clock::now();
		start1ticks = __rdtsc();
		for(int i =0; i < trials; ++i){
			results[i] = Vector3DotProduct(Vector1[i],Vector2[i]);
		}
		end1ticks = __rdtsc();
	end1 = std::chrono::steady_clock::now();
	// This is an 'okay' summary for measuring time and cycles.
	// cycle resolution may not be super accurate!
	std::cout<< "Dot Product Time: " << std::chrono::duration_cast<std::chrono::microseconds>(end1-start1).count() << "us\t" << "ticks=" << (end1ticks-start1ticks) << "\n";


	start1 = std::chrono::steady_clock::now();
		start1ticks = __rdtsc();
		for(int i =0; i < trials; ++i){
			results[i] = Vector3DotProduct(Vector1[i],Vector2[i]);
		}
		end1ticks = __rdtsc();
	end1 = std::chrono::steady_clock::now();
	// This is an 'okay' summary for measuring time and cycles.
	// cycle resolution may not be super accurate!
	std::cout<< "Dot Product Time: " << std::chrono::duration_cast<std::chrono::microseconds>(end1-start1).count() << "us\t" << "ticks=" << (end1ticks-start1ticks) << "\n";

	start1 = std::chrono::steady_clock::now();
		start1ticks = __rdtsc();
		for(int i =0; i < trials; ++i){
			results[i] = Vector3DotProduct(Vector1[i],Vector2[i]);
		}
		end1ticks = __rdtsc();
	end1 = std::chrono::steady_clock::now();
	// This is an 'okay' summary for measuring time and cycles.
	// cycle resolution may not be super accurate!
	std::cout<< "Dot Product Time: " << std::chrono::duration_cast<std::chrono::microseconds>(end1-start1).count() << "us\t" << "ticks=" << (end1ticks-start1ticks) << "\n";









	start1 = std::chrono::steady_clock::now();
		start1ticks = __rdtsc();
		for(int i =0; i < trials; ++i){
			avxresults1[i] = AVX_Vector3DotProduct1(Vector1[i],Vector2[i]);
		}
		end1ticks = __rdtsc();
	end1 = std::chrono::steady_clock::now();
	// This is an 'okay' summary for measuring time and cycles.
	// cycle resolution may not be super accurate!
	std::cout<< "AVX 1 Dot Product Time: " << std::chrono::duration_cast<std::chrono::microseconds>(end1-start1).count() << "us\t" << "ticks=" << (end1ticks-start1ticks) << "\n";


	start1 = std::chrono::steady_clock::now();
		start1ticks = __rdtsc();
		for(int i =0; i < trials; ++i){
			avxresults2[i] = AVX_Vector3DotProduct2(Vector1[i],Vector2[i]);
		}
		end1ticks = __rdtsc();
	end1 = std::chrono::steady_clock::now();
	// This is an 'okay' summary for measuring time and cycles.
	// cycle resolution may not be super accurate!
	std::cout<< "AVX 2 Dot Product Time: " << std::chrono::duration_cast<std::chrono::microseconds>(end1-start1).count() << "us\t" << "ticks=" << (end1ticks-start1ticks) << "\n";


	start1 = std::chrono::steady_clock::now();
		start1ticks = __rdtsc();
		for(int i =0; i < trials; ++i){
			avxresults3[i] = AVX_Vector3DotProduct3(Vector1[i],Vector2[i]);
		}
		end1ticks = __rdtsc();
	end1 = std::chrono::steady_clock::now();
	// This is an 'okay' summary for measuring time and cycles.
	// cycle resolution may not be super accurate!
	std::cout<< "AVX 3 Dot Product Time: " << std::chrono::duration_cast<std::chrono::microseconds>(end1-start1).count() << "us\t" << "ticks=" << (end1ticks-start1ticks) << "\n";

	// Validation (Make sure results are equal
	for(int i =0; i < trials; ++i){
		// std::cout << results[i] << " ? " << avxresults[i] << "\n"; // Uncomment to see results
		// Remember to be careful when comparing floats
		// Something like this is usually okay!
		if( std::abs(results[i] - avxresults1[i]) > 0.0001){
			std::cout << "Invalid experiment 1!\n";
			break;
		}
		if( std::abs(results[i] - avxresults2[i]) > 0.0001){
			std::cout << "Invalid experiment 2!\n";
			break;
		}
		if( std::abs(results[i] - avxresults3[i]) > 0.0001){
			std::cout << "Invalid experiment 3!\n";
			break;
		}
	}

	return 0;

}
